//
//  ROPCCredentials.swift
//  CocOAuth
//
//  Created by Marko Seifert on 02.06.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation
public class ROPCCredentials: Credentials {
    
    public let username: String
    public let password: String
    
    init(clientID: String, clientSecret: String, username: String, password: String) {

        self.username = username
        self.password = password
        super.init(clientID: clientID, clientSecret: clientSecret)
    }
}
