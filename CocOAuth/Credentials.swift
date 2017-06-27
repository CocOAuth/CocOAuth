//
//  Credentials.swift
//  CocOAuth
//
//  Created by Marko Seifert on 02.06.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation
public class Credentials {
    
    public let clientID:String
    public let clientSecret:String
    
    public init(clientID:String, clientSecret:String) {
        
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}
