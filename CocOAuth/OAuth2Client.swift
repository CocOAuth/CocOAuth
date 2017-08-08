//
//  OAuth2Client.swift
//  CocOAuth
//
//  Created by Marko Seifert on 09.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

internal typealias OAut2hCompletionHandler = (TokenResult?, OAuth2Error?) -> ()

internal class OAuth2Client{
    
    let config:OAuth2Config
    
    let credentialsStore:CredentialsStore
    
    internal init(config:OAuth2Config){
        self.config = config
        
        if let cs = config.credentialsStore{
            credentialsStore = cs
        } else {
            credentialsStore = InMemoryCredentialsStore()
        }
    }
    
    /**
     * Performs the OAut2 access token request with credentials.
     * This method is asynchronous. Use the completionHandler closures to handle success or error.
     * The client id and secret and the scopes are part oft the {@link CocOAuthConfig}.
     * @param username the user id
     * @param password the user´s password
     * @param completionHandler closures
     */
    internal func requestOAuthTokenWithCredentials(_ credentials: Credentials, handler : @escaping OAut2hCompletionHandler) -> Void {
        
        if let refreshCredentials = credentials as? RefreshCredentials{
        
            requestOAuthTokenWithRefreshToken(refreshTokenCredentials: refreshCredentials, handler: handler)
        }
        else if let ropcCredentials = credentials as? ROPCCredentials{
            
            requestOAuthTokenWithUsername(ropcCredentials, handler: handler)
        }
        else {
            requestOAuthToken(credentials: credentials, handler: handler)
        }
    }
    
    /**
    * Performs the OAut2 access token request with resource owner password credentials.
    * This method is asynchronous. Use the completionHandler closures to handle success or error.
    * The client id and secret and the scopes are part oft the {@link CocOAuthConfig}.
    * @param ropc credentials object with user name and password
    * @param completionHandler closures
    */
    internal func requestOAuthTokenWithUsername(_ ropc: ROPCCredentials, handler : @escaping OAut2hCompletionHandler) -> Void {
        
        let bodyString = "grant_type=password&username=\(ropc.username)&password=\(ropc.password)"
        requestOAuthTokenWithBody(clientID: ropc.clientID, clientSecret: ropc.clientSecret, body: bodyString, handler:handler)
    }
    /**
     * Performs the OAut2 access token request with client credentials.
     * This method is asynchronous. Use the completionHandler block to handle success or error.
     * The client credentials and the scopes are part oft the {@link CocOAuthConfig}.
     *
     * @param completionHandler block
     */
    internal func requestOAuthToken(credentials: Credentials, handler : @escaping OAut2hCompletionHandler){
        let bodyString = "grant_type=client_credentials"
        requestOAuthTokenWithBody(clientID: credentials.clientID, clientSecret: credentials.clientSecret, body: bodyString, handler: handler)
    }
    /**
     * Performs the OAut2 access token request with the authorization code.
     * This method is asynchronous. Use the completionHandler block to handle success or error.
     * The client id and secret and the scopes are part oft the {@link CocOAuthConfig}.
     * @param authoritazionCode the authorization code from a third party (or internal) identity provider
     */
    internal func requestOAuthTokenWithCode(authoritazionCode:String, handler : OAut2hCompletionHandler){
        
    }
    /**
     * Performs the OAut2 access token request with the refresh token.
     * This method is asynchronous. Use the completionHandler block to handle success or error.
     * The client id and secret and the scopes are part oft the {@link TSOAuth2Configuration}.
     * @param authcode the authorization code from a third party (or internal) identity provider
     * @param completionHandler block
     */
    internal func requestOAuthTokenWithRefreshToken(refreshTokenCredentials: RefreshCredentials, handler : @escaping OAut2hCompletionHandler){
        
        let bodyString = "grant_type=refresh_token&refresh_token=\(refreshTokenCredentials.refreshToken)"
        requestOAuthTokenWithBody(clientID: refreshTokenCredentials.clientID, clientSecret: refreshTokenCredentials.clientSecret, body: bodyString,handler: handler)
    }
    // MARK mark - private methods
    fileprivate func requestOAuthTokenWithBody(clientID:String,clientSecret:String, body:String, handler : @escaping OAut2hCompletionHandler){
    
        let session = URLSession.shared//(configuration: configuration)
        let request = NSMutableURLRequest(url: config.tokenURL)
        
        // Authorization header with client credentials
        
        let authHeader = _createAuthorizationHeader(clientID: clientID, clientSecret: clientSecret)
        request.addValue(authHeader, forHTTPHeaderField:"Authorization")
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        
        for key in config.additionalHeader.keys{
            request.addValue(config.additionalHeader[key]!, forHTTPHeaderField:key)
        }
        
        request.httpMethod = "POST"
        
        var requestBody = body
        if let scopes = config.scopes{
            if scopes.count > 0 {
                let scopeBody = scopes.joined(separator: " ")
                requestBody += "&scope="
                requestBody += scopeBody
            }
        }
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode != 200 {
                    let error = self.parseError(data: data, status:httpResponse.statusCode)
                    handler(nil, error)
                } else {
                    do{
                        let tokenResult = try self.parseDate(clientID:clientID,clientSecret:clientSecret,data: data)
                        handler(tokenResult, nil)
                    } catch let err as OAuth2Error{
                        handler(nil, err)
                    }
                    catch{
                        let err = OAuth2Error(errorMessage:error.localizedDescription, kind:.internalError, error:error)
                        handler(nil, err)
                    }
                }
                return
            }
            if let e = error  {
                let err = OAuth2Error(errorMessage:e.localizedDescription, kind:.internalError, error:e)
                handler(nil, err)
                return
            }
        }
        task.resume()
    }
    
    fileprivate func _createAuthorizationHeader(clientID:String,clientSecret:String) -> (String) {
        
        let authCredentials = "\(clientID):\(clientSecret)"
        let utf8str = authCredentials.data(using: String.Encoding.utf8)
        let base64String = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return "Basic \(base64String!)";
    }
    fileprivate func parseDate(clientID:String,clientSecret:String,data:Data?) throws -> TokenResult{

        if let d = data{
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: d, options: [])
                
                let jsonDic = jsonObject as! [String:Any]
                if let accessToken = jsonDic["access_token"]{
                    var refreshToken:String? = nil
                    if let rToken = jsonDic["refresh_token"] as? String{
                        refreshToken = rToken
                        credentialsStore.storeCredentials(RefreshCredentials(clientID:clientID,clientSecret:clientSecret, refreshToken: rToken))
                    }else{
                        credentialsStore.storeCredentials(Credentials(clientID:clientID,clientSecret:clientSecret))
                    }
                    var expiresIn:Int = 0
                    if let expIn = jsonDic["expires_in"] as? Int{
                        expiresIn = expIn
                    }
                    let date = Date()
                    let currentTime = date.timeIntervalSince1970
                    return TokenResult(accessToken: accessToken as! String, refreshToken: refreshToken, expiresIn:Double(expiresIn), timestamp: currentTime)
                }
                throw OAuth2Error(errorMessage: "unable to parse access token", kind: .unsupportedResponseType, error: nil)
            }
            catch let error {
                throw OAuth2Error(errorMessage: "unable to parse the payload", kind: .unsupportedResponseType, error: error)
            }
        } else {
            throw OAuth2Error(errorMessage: "unable to parse access token, no payload available", kind: .unsupportedResponseType, error: nil)
            
        }
    }
    fileprivate func parseError(data:Data?, status:Int) -> OAuth2Error{

        var error = OAuth2Error(errorMessage:String(format: "HTTP Code: %d", status), kind:.serverError, error:nil)
        
        if let d = data{
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: d, options: [])
                
                let jsonDic = jsonObject as! [String:Any]
                
                var errorCode = ""
                if let eCode = jsonDic["error"] as? String{
                 
                    errorCode = eCode
                }
                var errorDescription = ""
                if let eDescription = jsonDic["error_description"] as? String{
                    errorDescription = eDescription
                } else if let eMessage = jsonDic["message"] as? String{
                    errorDescription = eMessage
                }
                print(errorCode)
                error = OAuth2Error(errorMessage: errorDescription, kind: OAuth2Error.ErrorKind.fromString(errorCode), error: nil)
            }
            catch let err {
                error = OAuth2Error(errorMessage: "unable to parse the payload", kind: .unsupportedResponseType, error: err)
            }
        }
        return error
    }

}
