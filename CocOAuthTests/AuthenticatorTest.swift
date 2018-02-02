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
    
    
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let authenticator = makeAuthenticator()
        
        let authExpectation = XCTestExpectation(description: "authenticate")
        authenticator.authenticateWithClientCredentials { (success, error) in
            XCTAssert(success)
            XCTAssertNil(error)
            authExpectation.fulfill()
        }
        wait(for: [authExpectation], timeout: 10.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func makeAuthenticator() -> Authenticator{
        let config = OAuth2Config(tokenURL: URL(string:"https://dummy.com/oaut/token")!, clientID: "clientID", clientSecret: "clinetsecret")
        let responseString = "{\"login\": \"dasdom\", \"id\": 1234567}"
        let response = HTTPURLResponse(url: config.tokenURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        let responseData = responseString.data(using: String.Encoding.utf8)!
        
        config.session = URLSessionMock(data: responseData, response: response, error: nil)
        let authenticator = Authenticator(config: config)
        return authenticator
    }
    
}
