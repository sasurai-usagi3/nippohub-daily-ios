//
//  AccountManager.swift
//  nippohub-daily
//
//  Created by うさきち on 2019/04/09.
//  Copyright © 2019 うーぴょん. All rights reserved.
//

import Foundation
import Firebase

final class AccountRepository {
    static let instance = AccountRepository()
    
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
    
    // TODO: error型を返さないようにする
    func signIn(email: String, password: String, onCompletion: (() -> Void)?, onFail: ((Error) -> Void)?) {
        auth.signIn(withEmail: email, password: password) { res, err in
            if let err = err {
                onFail?.self(err)
            } else {
                onCompletion?.self()
            }
        }
    }
    
    func signUp(email: String, password: String, onCompletion: (() -> Void)?, onFail: ((Error) -> Void)?) {
        auth.createUser(withEmail: email, password: password) { res, err in
            if let err = err {
                onFail?.self(err)
            } else {
                onCompletion?.self()
            }
        }
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
