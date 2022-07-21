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
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "^")
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
        database.child("User").child(user.id).setValue([
            "id": user.id,
            "name": user.name,
            "email": user.emailAddress,
            "color": user.color,
            "status": "no status"
        ])
    }
    
    

    public func getUser(with id: String,
                         completion: @escaping ((ChatAppUser)-> Void)) {
              
        database.child("User").child(id).observeSingleEvent(of: .value, with: {snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let textColor = value?["color"] as? String ?? ""
            let status = value?["status"] as? String ?? ""
            completion(ChatAppUser(id: id, name: name, emailAddress: email, color: textColor, status: status))
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    
}

struct  ChatAppUser {
    let id: String
    let name: String
    let emailAddress: String
    let color: String
    let status: String
}

