//
//  CocOAuthConfig.swift
//  CocOAuth
//
//  Created by Marko Seifert on 09.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

public class CocOAuthConfig{
    
    var scopes:[String]?
    var tokenURL:NSURL
    var requestTimeout:UInt = 15
    var clientID:String
    var clientSecret: String
    
    public init(tokenURL:NSURL, clientID:String, clientSecret:String, scopes:[String]? = [], timeout:UInt? = 15){
        self.tokenURL = tokenURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.scopes = scopes
        self.requestTimeout = timeout!
    }
    
}
