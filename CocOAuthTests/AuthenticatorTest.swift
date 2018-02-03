//
//  AuthenticatorTest.swift
//  CocOAuthTests
//
//  Created by Marko Seifert on 08.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import XCTest
@testable import CocOAuth

class AuthenticatorTest: XCTestCase {
    
    let errors: [String] = ["invalid_request", "invalid_client", "invalid_callback", "invalid_grant", "unauthorized_client", "unauthorized", "unsupported_grant_type", "invalid_scope", "access_denied", "unsupported_response_type", "server_error", "temporarily_unavailable"]
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticateWithClientSuccess() {
        let accessToken = "a05a793c-9d80-4221-a99d-ad473ccd1989"
        let config = makeConfig()
        var body = [String: Any]()
        body["access_token"] = accessToken
        body["token_type"] = "bearer"
        body["expires_in"] = 600
        
        let data = try! makeResponceData(data: body)
        let authenticator = makeAuthenticator(response: makeResponce(config: config, statusCode: 200), responseData: data, error: nil, config: config)
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        authenticator.authenticateWithClientCredentials { (success, error) in
            XCTAssert(success)
            XCTAssertNil(error)
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)

        let tokenExpectation = XCTestExpectation(description: "retrieve oauth access token")
        authenticator.retrieveAccessToken { (atoken, error) in
            XCTAssertNotNil(atoken)
            XCTAssertNil(error)
            XCTAssertEqual(accessToken, atoken)
            tokenExpectation.fulfill()
        }
        wait(for: [tokenExpectation], timeout: 10.0)
    }
    
    func testAuthenticateWithClientScopesSuccess() {
        let accessToken = "a05a793c-9d80-4221-a99d-ad473ccd1989"
        let config = makeConfig(scopesAndHeader: true)
        var body = [String: Any]()
        body["access_token"] = accessToken
        body["token_type"] = "bearer"
        body["expires_in"] = 600
        
        let data = try! makeResponceData(data: body)
        let authenticator = makeAuthenticator(response: makeResponce(config: config, statusCode: 200), responseData: data, error: nil, config: config)
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        authenticator.authenticateWithClientCredentials { (success, error) in
            XCTAssert(success)
            XCTAssertNil(error)
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)
        
        let tokenExpectation = XCTestExpectation(description: "retrieve oauth access token")
        authenticator.retrieveAccessToken { (atoken, error) in
            XCTAssertNotNil(atoken)
            XCTAssertNil(error)
            XCTAssertEqual(accessToken, atoken)
            tokenExpectation.fulfill()
        }
        wait(for: [tokenExpectation], timeout: 10.0)
    }
    
    func testAuthenticateWithUserSuccess() {
        let accessToken = "a05a793c-9d80-4221-a99d-ad473ccd1989"
        let refreshToken = "a05a793c-ad473ccd19-899d80-4221-a99d"
        let config = makeConfig()
        var body = [String: Any]()
        body["access_token"] = accessToken
        body["refresh_token"] = refreshToken
        body["token_type"] = "bearer"
        body["expires_in"] = 400
        
        let data = try! makeResponceData(data: body)
        let authenticator = makeAuthenticator(response: makeResponce(config: config, statusCode: 200), responseData: data, error: nil, config: config)
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        authenticator.authenticateWithUsername("Max", password: "Password") { (success, error) in
            XCTAssert(success)
            XCTAssertNil(error)
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)
        
        XCTAssertTrue(authenticator.isAccessTokenValid().valid)
        XCTAssertNotNil(authenticator.tokenResult)
        XCTAssertEqual(authenticator.tokenResult!.refreshToken, refreshToken)
        
        authenticator.tokenResult = TokenResult(accessToken: accessToken, refreshToken: refreshToken, expiresIn: 0, timestamp: authenticator.tokenResult!.timestamp)
        XCTAssertFalse(authenticator.isAccessTokenValid().valid)
        
        let tokenExpectation = XCTestExpectation(description: "retrieve oauth access token")
        authenticator.retrieveAccessToken { (atoken, error) in
            XCTAssertNotNil(atoken)
            XCTAssertNil(error)
            XCTAssertEqual(accessToken, atoken)
            tokenExpectation.fulfill()
        }
        wait(for: [tokenExpectation], timeout: 10.0)
    }
    
    func testAuthenticateWithClientSuccessExpiredToken() {
        let accessToken = "a05a793c-9d80-4221-a99d-ad473ccd1989"
        let config = makeConfig()
        var body = [String: Any]()
        body["access_token"] = accessToken
        body["token_type"] = "bearer"
        body["expires_in"] = 100 // expired
        
        let data = try! makeResponceData(data: body)
        let authenticator = makeAuthenticator(response: makeResponce(config: config, statusCode: 200), responseData: data, error: nil, config: config)
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        
        authenticator.authenticateWithClientCredentials { (success, error) in
            XCTAssert(success)
            XCTAssertNil(error)
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)

        XCTAssertTrue(authenticator.isAccessTokenValid().valid)
        XCTAssertNotNil(authenticator.tokenResult)
        authenticator.tokenResult = TokenResult(accessToken: accessToken, refreshToken: nil, expiresIn: 0, timestamp: authenticator.tokenResult!.timestamp)
        XCTAssertFalse(authenticator.isAccessTokenValid().valid)
        
        let tokenExpectation = XCTestExpectation(description: "retrieve oauth access token")
        authenticator.retrieveAccessToken { (atoken, error) in
            XCTAssertNotNil(atoken)
            XCTAssertNil(error)
            XCTAssertEqual(accessToken, atoken)
            tokenExpectation.fulfill()
        }
        wait(for: [tokenExpectation], timeout: 10.0)
    }
    
    func testAuthenticateWithClientFailsWrongData() {
        let accessToken = "a05a793c-9d80-4221-a99d-ad473ccd1989"
        let config = makeConfig()
        var body = [String: Any]()
        body["access_tok"] = accessToken
        body["token_type"] = "bearer"
        body["expires_in"] = 989
        
        let data = try! makeResponceData(data: body)
        let authenticator = makeAuthenticator(response: makeResponce(config: config, statusCode: 200), responseData: data, error: nil, config: config)
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        authenticator.authenticateWithClientCredentials { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            
            if let e = error, e.kind == OAuth2Error.ErrorKind.fromString("unsupported_response_type") {
                XCTAssert(true)
            } else {
                XCTFail("eror")
            }
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)
    }
    
    func testAuthenticateWithClientFailsWithError() {
        let config = makeConfig()
        let error = OAuth2Error(errorMessage: "", kind: OAuth2Error.ErrorKind.invalidGrant, error: nil)
        let authenticator = makeAuthenticator(response: nil, responseData: nil, error: error, config: config)
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        authenticator.authenticateWithClientCredentials { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            
            if let e = error, e.kind == OAuth2Error.ErrorKind.fromString("internal_error") {
                XCTAssert(true)
            } else {
                XCTFail("eror")
            }
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)
        
    }
    
    func testAuthenticateWithClientFailsWithOAuthErrors() {
        let config = makeConfig()
        
        for e in errors {
            var body = [String: Any]()
            let kind = OAuth2Error.ErrorKind.fromString(e)
            body["error"] = e
            body["error_description"] = "bla"
            
            let data = try! makeResponceData(data: body)
            let authenticator = makeAuthenticator(response: makeResponce(config: config, statusCode: 400), responseData: data, error: nil, config: config)
            
            let authExpectation = XCTestExpectation(description: "authenticate")
            authenticator.authenticateWithClientCredentials { (success, error) in
                XCTAssertFalse(success)
                XCTAssertNotNil(error)
                
                if let e = error, e.kind == kind {
                    XCTAssert(true)
                } else {
                    XCTFail("eror")
                }
                authExpectation.fulfill()
            }
            wait(for: [authExpectation], timeout: 10.0)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func makeAuthenticator(response: HTTPURLResponse?, responseData: Data?, error: Error?, config: OAuth2Config) -> Authenticator {
        
        config.session = URLSessionMock(data: responseData, response: response, error: error)
        let authenticator = Authenticator(config: config)
        return authenticator
    }
    private func makeResponceData(data: [String: Any]) throws -> Data {
        let jsonData =  try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions())
        return jsonData
    }
    private func makeResponce(config: OAuth2Config, statusCode: Int) -> HTTPURLResponse? {
        
        let response = HTTPURLResponse(url: config.tokenURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        return response
    }
    private func makeConfig(scopesAndHeader: Bool = false) -> OAuth2Config {
        if scopesAndHeader {
            return OAuth2Config(tokenURL: URL(string: "https://dummy.com/oaut/token")!, clientID: "clientID", clientSecret: "clinetsecret")
        } else {
            return OAuth2Config(tokenURL: URL(string: "https://dummy.com/oaut/token")!, clientID: "clientID", clientSecret: "clinetsecret", additionalHeader: ["tenant": "A"], scopes: ["ScopeA", "ScopeB"], timeout: 0)
        }
    }
}

/*
 400
 {
 "error": "unsupported_grant_type",
 "error_description": "Unsupported grant type: client_credential",
 "detailedErrorCode": "5003",
 "errorMessage": "Invaild grant type"
 }
 
 */
