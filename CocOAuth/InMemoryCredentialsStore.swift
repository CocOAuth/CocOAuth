//
//  InMemoryCredentialsStore.swift
//  CocOAuth
//
//  Created by Marko Seifert on 02.06.17.
//  Copyright © 2017 CocOAuth. All rights reserved.
//

import Foundation

class InMemoryCredentialsStore: CredentialsStore {
    
    private var internalStore: Credentials?
    
    func loadCredentials() -> Credentials? {
        return internalStore
    }
    func storeCredentials(_ credentials: Credentials) {
        internalStore = credentials
    }
    func removeCredentials() {
        internalStore = nil
    }
}
