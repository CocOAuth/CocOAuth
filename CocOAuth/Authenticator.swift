//
//  Authenticator.swift
//  CocOAuth
//
//  Created by Marko Seifert on 08.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

open class Authenticator{
    
    public typealias AuthenticationCompletionHandler = (Bool, OAuth2Error?) -> ()
    public typealias AccessTokenCompletionHandler = (String?, OAuth2Error?) -> ()
    
    let config:OAuth2Config
    let client:OAuth2Client
    var tokenResult : TokenResult?
    
    private let mutex = PThreadMutex()
    private var completionHandlerQueue: [AccessTokenCompletionHandler] = []
    
    enum CocOAuthError: Error {
        case invalidUserCredentialsError
        case offlineError
        case timeOutError
        case technicalError
    }
    public init(config:OAuth2Config){
        self.config = config
        client = OAuth2Client(config: config)
    }
    
    /**
     * Performs the authentication with client credentials.
     * This method is asynchronous. Use the completionHandler block to handle success or error.
     *
     * @param AuthenticationCompletionHandler block
     */
    open func authenticateWithClientCredentials(handler : @escaping AuthenticationCompletionHandler) -> Void {
        
        let credentials = Credentials(clientID: config.clientID, clientSecret: config.clientSecret)
        client.requestOAuthTokenWithCredentials(credentials, handler: { (result, error) in
            
            if(error == nil){
                self.tokenResult = result
                DispatchQueue.main.async {
                    handler(true, error)
                }
            } else {
                DispatchQueue.main.async {
                    handler(false, error)
                }
            }
        })
    }
    
    /**
    * Performs the authentication with resource owner password credentials.
    * This method is asynchronous. Use the completionHandler block to handle success or error.
    *
    * @param username the OAuth2 username
    * @paramter password the OAuth2 password
    * @param AuthenticationCompletionHandler block
    */
    open func authenticateWithUsername(_ username:String,password :String, handler : @escaping AuthenticationCompletionHandler) -> Void {
        
        let ropc = ROPCCredentials(clientID: config.clientID, clientSecret: config.clientSecret, username: username, password: password)
        client.requestOAuthTokenWithCredentials(ropc, handler: { (result, error) in
            
            if(error == nil){
                self.tokenResult = result
                DispatchQueue.main.async {
                    handler(true, error)
                }
            } else {
                DispatchQueue.main.async {
                    handler(false, error)
                }
                
            }
        })
    }
    
    /**
     Method retrieves an auth token for the api authorization if the accout is authenticated.
     This method refresh the access token automatically, if the token is expired.
     This method is asynchronous.
     */
    open func retrieveAccessToken(handler : @escaping AccessTokenCompletionHandler){
        
        let validAccessToken = isAccessTokenValid()
    
        if(validAccessToken.valid){
            DispatchQueue.main.async {
                handler(validAccessToken.accessToken, nil)
            }
            return
        }
        else{
            
            if let credential = client.credentialsStore.loadCredentials() {
                mutex.sync(execute: { [weak self] () -> Void in
                    self?.completionHandlerQueue.append(handler)
                    
                    if self?.completionHandlerQueue.count == 1 {
                        self?.client.requestOAuthTokenWithCredentials(credential) { (result, error) in
                            
                            DispatchQueue.main.async {
                                self?.tokenResult = result
                                
                                self?.completionHandlerQueue.forEach {
                                    $0(result?.accessToken, error)
                                }
                                
                                self?.completionHandlerQueue.removeAll()
                            }
                        }
                    }
                })
            } else {
                let error = OAuth2Error(errorMessage: "no credentials available", kind: .unauthorized, error: nil)
                DispatchQueue.main.async {
                    handler(nil, error)
                }
            }
        }
    }
    
    /**
     * app access token is not valid
     */
    open func invalidateAuthToken(){
        
    }
    
    /**
     * Invalidates and forgets the authentication object including the auth token.
     * If the credentials are stored because reuse-for-uthentication is set to YES, the credentials are also removed.
     *
     * This should be called when the user explicitly signs off from your app.
     */
    open func signOff(){
        
    }
    
    private func isAccessTokenValid() -> (valid:Bool, accessToken:String){
        if let tr = tokenResult{
            let accessToken = tr.accessToken
            let date = Date()
            let currentTime = date.timeIntervalSince1970
            if currentTime - tr.timestamp < tr.expiresIn{
                return (true,accessToken)
            }
            
        }
        return (false,"")

    }
}
