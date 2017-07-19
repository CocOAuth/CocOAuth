//
//  OAuth2Error.swift
//  CocOAuth
//
//  Created by Marko Seifert on 31.05.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation


public struct OAuth2Error: Error {
    enum ErrorKind {
        case invalidRequest
        case invalidClient
        case invalidCallback
        case invalidGrant
        case unauthorizedClient
        case unauthorized
        case unsupportedGrantType
        case invalidScope
        case accessDenied
        case unsupportedResponseType
        case serverError
        case temporarilyUnavailable
        case internalError
        
        static func fromString(_ errorCode: String) -> ErrorKind {
            var error = ErrorKind.internalError
            switch errorCode.lowercased() {
                
            case "invalid_request":
                error = invalidRequest
                break
            case "invalid_client":
                error = invalidClient
                break
            case "invalid_callback":
                error = invalidCallback
                break
            case "invalid_grant":
                error = invalidGrant
                break
            case "unauthorized_client":
                error = unauthorizedClient
                break
            case "unauthorized":
                error = unauthorized
                break
            case "unsupported_grant_type":
                error = unsupportedGrantType
                break
            case "invalid_scope":
                error = invalidScope
                break
            case "access_denied":
                error = accessDenied
                break
            case "unsupported_response_type":
                error = unsupportedResponseType
                break
            case "server_error":
                error = serverError
                break
            case "temporarily_unavailable":
                error = temporarilyUnavailable
                break
            case "internal_error":
                error = internalError
                break
            default:
                error = internalError
                break
            }
            return error
        }
    }
    
    let errorMessage: String
    let kind: ErrorKind
    let error:Error?
    public var localizedDescription: String {
        get {
            return errorMessage
        }
    }
    
}
