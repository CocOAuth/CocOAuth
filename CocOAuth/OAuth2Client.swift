//
//  OAuth2Client.swift
//  CocOAuth
//
//  Created by Marko Seifert on 09.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

internal class OAuth2Client{
    
    let config:CocOAuthConfig
    
    internal typealias OAuth2CompletionHandler = () -> ()
    
    internal init(config:CocOAuthConfig){
        self.config = config
    }
    
    /**
    * Performs the OAut2 access token request with resource owner password credentials.
    * This method is asynchronous. Use the completionHandler closures to handle success or error.
    * The client id and secret and the scopes are part oft the {@link TODO}.
    * @param username the user id
    * @param password the user´s password
    * @param completionHandler closures
    */
    internal func requestOAuthTokenWithUsername(username: String, password:String, handler : OAuth2CompletionHandler) -> Void {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let request = NSMutableURLRequest(URL: config.tokenURL)
        
        
        // Authorization header with client credentials
        
        let authHeader = _createAuthorizationHeader()
        request.addValue(authHeader, forHTTPHeaderField:"Authorization")
        
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        request.HTTPMethod = "POST"
        
        
        let bodyString = "grant_type=password&username=\(username)&password=\(password)"
        NSLog("request: \(bodyString)\\n\(request)")
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("response was not 200: \(response)")
                    //return
                }
                let datastring = NSString(data:data!, encoding:NSUTF8StringEncoding) as String?
                NSLog("response was: \(datastring)")
            }
            if (error != nil) {
                NSLog("error submitting request: \(error)")
                //return
            }
        }
        task.resume()
    
    }
    
    // MARK mark - private methods
    
    private func _createAuthorizationHeader() -> (String) {
        
        let authCredentials = "\(config.clientID):\(config.clientSecret)"
        let utf8str = authCredentials.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return "Basic \(base64String!)";
    }

}
