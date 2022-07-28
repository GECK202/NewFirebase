//
//  DatabaseManager.swift
//  FB
//
//  Created by Valeria Karon on 7/28/22.
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
        ])}
    
    /*
    , withCompletionBlock: {[weak self] error, _ in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Ошибка записи пользователя в базу данных!")
                return
            }
            strongSelf.database.child("User").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    let newElement = [
                        "name": user.name,
                        "email": user.emailAddress,
                        "status": user.status
                    ]
                    usersCollection.append(newElement)
                    strongSelf.database.child("User").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                    })
                }
                else {
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.name,
                            "email": user.emailAddress,
                            "status": user.status
                        ]
                    ]
                    
                    strongSelf.database.child("User").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                    })
                }
            })
        })
    }
     */
    
    

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
    
    public func getAllUsers(completion: @escaping (([ChatAppUser])->Void)) {
        var users: [ChatAppUser] = []
        self.database.child("User").observeSingleEvent(of: .value, with: { snapshot in
            guard let dic = snapshot.value as? NSDictionary else {
                completion(users)
                return
            }
            
            for (_, v) in dic {
                guard let value = v as? NSDictionary, let id = value["id"] as? String else {
                    continue
                }
                let name = value["name"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let textColor = value["color"] as? String ?? ""
                let status = value["status"] as? String ?? ""
                users.append(ChatAppUser(id: id, name: name, emailAddress: email, color: textColor, status: status))
                    //print("\(name), \(email), \(textColor), \(status)")
            }
            completion(users)
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

