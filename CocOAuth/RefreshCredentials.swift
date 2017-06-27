//
//  RefreshCredentials.swift
//  CocOAuth
//
//  Created by Marko Seifert on 02.06.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation
public class RefreshCredentials: Credentials{
    
    public let refreshToken:String
    
    public init(clientID: String, clientSecret: String, refreshToken:String) {
        self.refreshToken = refreshToken
        super.init(clientID: clientID, clientSecret: clientSecret)
        
    }
}
