//
//  OAuth2Error.swift
//  CocOAuth
//
//  Created by Marko Seifert on 31.05.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation

public struct OAuth2Error: Error {
    public enum ErrorKind {
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
            case "invalid_client":
                error = invalidClient
            case "invalid_callback":
                error = invalidCallback
            case "invalid_grant":
                error = invalidGrant
            case "unauthorized_client":
                error = unauthorizedClient
            case "unauthorized":
                error = unauthorized
            case "unsupported_grant_type":
                error = unsupportedGrantType
            case "invalid_scope":
                error = invalidScope
            case "access_denied":
                error = accessDenied
            case "unsupported_response_type":
                error = unsupportedResponseType
            case "server_error":
                error = serverError
            case "temporarily_unavailable":
                error = temporarilyUnavailable
            case "internal_error":
                error = internalError
            default:
                error = internalError
            }
            return error
        }
    }
    
    public let errorMessage: String
    public let kind: ErrorKind
    let error: Error?
    public var localizedDescription: String {
        return errorMessage
    
    }
    
}
