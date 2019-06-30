//
//  AccountManager.swift
//  nippohub-daily
//
//  Created by うさきち on 2019/04/09.
//  Copyright © 2019 うーぴょん. All rights reserved.
//

import Foundation
import Firebase

final class AccountManager {
    static let instance = AccountManager()
    
    private let auth = Auth.auth()
    
    var currentUser: Account? {
        guard let user = auth.currentUser else { return nil }
        
        return Account(id: user.uid, email: user.email!)
    }
    
    private init() {
    }
    
    func didSetUp(listener: @escaping AuthStateDidChangeListenerBlock) {
        auth.addStateDidChangeListener(listener)
    }
    
    func signIn(email: String, password: String, completion: @escaping AuthDataResultCallback) {
        auth.signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signUp(email: String, password: String, completion: @escaping AuthDataResultCallback) {
        auth.createUser(withEmail: email, password: password, completion: completion)
    }
    
    @discardableResult
    func signOut() -> Bool {
        do {
           try auth.signOut()
            
            return true
        } catch {
            return false
        }
    }
}
