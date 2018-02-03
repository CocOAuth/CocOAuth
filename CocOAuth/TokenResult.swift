//
//  TokenResult.swift
//  CocOAuth
//
//  Created by Marko Seifert on 09.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import Foundation

struct TokenResult {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Double
    let timestamp: TimeInterval
}
