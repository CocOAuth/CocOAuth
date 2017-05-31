//
//  OAuth2Error.swift
//  CocOAuth
//
//  Created by Marko Seifert on 31.05.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation


struct OAuth2Error: Error {
    enum ErrorKind {
        case invalidRequest
        case invalidClient
        case invalidCallback
        case invalidGrant
        case unauthorizedClient
        case unsupportedCrant_type
        case invalidScope
        case accessDenied
        case unsupportedResponseType
        case serverError
        case temporarilyUnavailable
        case internalError
    }
    
    let errorMessage: String
    let kind: ErrorKind
    let error:Error?
}
