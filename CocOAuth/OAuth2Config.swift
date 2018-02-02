//
//  OAuth2Config.swift
//  CocOAuth
//
//  Created by Marko Seifert on 09.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

open class OAuth2Config{
    
    let scopes:[String]?
    let tokenURL:URL
    let requestTimeout:UInt
    let clientID:String
    let clientSecret: String
    let additionalHeader: [String:String]
    
    open var credentialsStore: CredentialsStore?
    var session: URLSessionProtocol?
    
    
    public init(tokenURL:URL, clientID:String, clientSecret:String, additionalHeader: [String:String]=[String:String](), scopes:[String] = [], timeout:UInt = 15){
        self.tokenURL = tokenURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.requestTimeout = timeout
        self.additionalHeader = additionalHeader
    }
    
}
