//
//  Authenticator.swift
//  CocOAuth
//
//  Created by Marko Seifert on 08.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

open class Authenticator{
    
    public typealias CompletionHandler = (Bool, String?) -> ()
    
    let config:OAuth2Config
    let client:OAuth2Client
    
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
    * Performs the authentication with resource owner password credentials.
    * This method is asynchronous. Use the completionHandler block to handle success or error.
    *
    * @param username
    *          the OAuth2 username
    *
    * @paramter password
    *          the OAuth2 password
    *
    * @param completionHandler block
    */
    open func authenticateWithUsername(_ username:String,password :String, handler : @escaping CompletionHandler) -> Void {
        
        client.requestOAuthTokenWithUsername(username, password: password) { (result, error) in
            
            print(result)
            print(error)
            var success = false
            var message : String?
            if(error == nil){
                success = true
                
                DispatchQueue.main.async {
                    handler(success, message)
                }
            } else {
                success = false
                if let err = error{
                    let oauthError = err as! OAuth2Error
                    message = oauthError.errorMessage

                    DispatchQueue.main.async {
                        handler(success, message)
                    }
                }
            }
        }
        
    }
}
