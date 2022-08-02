//
//  DatabaseManager.swift
//  FB
//
//  Created by Valeria Karon on 7/28/22.
//

import Foundation
import FirebaseDatabase
import UIKit

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private var user: ChatAppUser?
    
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
    public func insertUser(with user: ChatAppUser, competition: ((Bool)->Void)? ) {
        database.child("User").child(user.id).setValue([
            "id": user.id,
            "name": user.name,
            "email": user.emailAddress,
            "color": user.color,
            "status": user.status
        ]) {(error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                if let competition = competition {
                    competition(false)
                }
            } else {
                print("Data saved successfully!")
                if let competition = competition {
                    competition(true)
                }
            }
          }
    }
    

    public func getUser(with id: String,
                        completion: @escaping ((ChatAppUser)-> Void)) {
        if self.user == nil {
            database.child("User").child(id).observeSingleEvent(of: .value, with: {snapshot in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let textColor = value?["color"] as? String ?? ""
                let status = value?["status"] as? String ?? ""
                self.user = ChatAppUser(id: id, name: name, emailAddress: email, color: textColor, status: status)
                completion(self.user!)
            }) { error in
                print(error.localizedDescription)
                return
            }
        } else {
            completion(self.user!)
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
            }
            completion(users)
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    public func findUsers(findString: String, completion: @escaping (([ChatAppUser])->Void)) {
        var users: [ChatAppUser] = []
        
        let query = self.database.child("User").queryOrdered(byChild: "email").queryStarting(atValue: findString).queryLimited(toFirst: 20)
        
        let userEmail = UserDefaults.standard.string(forKey: "email")
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            guard let dic = snapshot.value as? NSDictionary else {
                completion(users)
                return
            }
            for (_, v) in dic {
                guard let value = v as? NSDictionary, let id = value["id"] as? String else {
                    continue
                }
                let email = value["email"] as? String ?? ""
                if email.hasPrefix(findString) && (email != userEmail) {
                    let name = value["name"] as? String ?? ""
                    let textColor = value["color"] as? String ?? ""
                    let status = value["status"] as? String ?? ""
                    users.append(ChatAppUser(id: id, name: name, emailAddress: email, color: textColor, status: status))
                }
            }
            completion(users)
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
    
}

extension DatabaseManager {
    
    public func getAllConversations(for id: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(id)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                          return nil
                      }
                
                let latestMmessageObject = LatestMessage(date: date,
                                                         text: message,
                                                         isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMmessageObject)
            })
            
            completion(.success(conversations))
        })
    }
    
}

