//
//  Credentials.swift
//  CocOAuth
//
//  Created by Marko Seifert on 02.06.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation
public struct Credentials {
    public let refreshToken:String
    public init(refreshToken:String) {
        self.refreshToken = refreshToken
    }
}
