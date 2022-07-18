//
//  DatabaseManager.swift
//  MyFirstFirebaseProject
//
//  Created by Valeria Karon on 7/15/22.
//  Copyright © 2022 Valeria Karon. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
        
}

extension DatabaseManager {
    
    public func userExists(with email: String, competition: @escaping ((Bool) -> (Void))){
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                competition(false)
                return
            }
            competition(true)
        })
    }
    
    
    ///Insert new user to database
    public func insertUser(with user: ChatAppUser) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: user.emailAddress)
       
        database.child("users").child(safeEmail).setValue([
            "name": user.name,
            "color": String(UIColor.random().hex),
            "status": "no status"
        ])
    }
}

struct  ChatAppUser {
    let name: String
    let emailAddress: String
}

