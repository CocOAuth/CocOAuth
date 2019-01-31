//
//  OAuth2Error.swift
//  CocOAuth
//
//  Created by Marko Seifert on 31.05.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation

public struct OAuth2Error: Error {
    public enum ErrorKind: Equatable {
        case invalidRequest
        case invalidClient
        case invalidCallback
        case invalidGrant
        case unauthorizedClient
        case unauthorized(String?)
        case unsupportedGrantType
        case invalidScope
        case accessDenied
        case unsupportedResponseType
        case serverError
        case temporarilyUnavailable
        case internalError
        
        static func fromString(_ errorCode: String, subCode: String? = nil) -> ErrorKind {
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
                error = unauthorized(subCode)
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
        public static func ==(ek1: ErrorKind, ek2: ErrorKind) -> Bool {
            switch (ek1, ek2) {
            case (let .unauthorized(a1), let .unauthorized(a2)):
                return a1 == a2
            case (.invalidRequest, .invalidRequest), (.invalidClient, .invalidClient) ,(.invalidCallback, .invalidCallback), (.unauthorizedClient,.unauthorizedClient), (.unsupportedGrantType,.unsupportedGrantType), (.invalidScope,.invalidScope),(.accessDenied,.accessDenied), (.unsupportedResponseType,.unsupportedResponseType), (.serverError,.serverError), (.temporarilyUnavailable,.temporarilyUnavailable), (.invalidGrant, .invalidGrant),(.internalError, .internalError):
                return true

            default:
                return false
            }
        }
    }
    
    public let errorMessage: String
    public let kind: ErrorKind
    let error: Error?
    public var localizedDescription: String {
        return errorMessage
    
    }
    
}
