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
    
    public init(tokenURL:URL, clientID:String, clientSecret:String, scopes:[String]? = [], timeout:UInt = 15){
        self.tokenURL = tokenURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.requestTimeout = timeout
    }
    
}
