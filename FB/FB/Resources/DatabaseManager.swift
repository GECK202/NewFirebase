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
    
    private var sharedKey = "";
    
    private var user: ChatAppUser?
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "^")
        return safeEmail
    }
}

//MARK: Find users
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
    
    public func getCurrentUser()->ChatAppUser? {
        return self.user
    }
    
    public func getUser(with id: String,
                        completion: @escaping ((ChatAppUser)-> Void)) {
        //if self.user == nil {
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
        //} else {
        //    completion(self.user!)
       // }
        
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
    
    public func findContacts(completion: @escaping(([ChatAppUser])->Void)) {
        var users: [ChatAppUser] = []
        
        let query = self.database.child("UsersKey")
        
        
        guard let userEmail = UserDefaults.standard.string(forKey: "email") else {
            completion(users)
            return
        }
        
        query.observeSingleEvent(of: .value, with: {snapshot in
            guard let dic = snapshot.value as? NSDictionary else {
                completion(users)
                return
            }
            for (_, v) in dic {
                guard let value = v as? NSDictionary, let usersEmailString = value["users"] as? String else {
                    continue
                }
                let usersEmail:[String] = usersEmailString.components(separatedBy: " ")
                var contactEmail: String?
                if (usersEmail[0] == userEmail) {
                    contactEmail = usersEmail[1]
                }
                if (usersEmail[1] == userEmail) {
                    contactEmail = usersEmail[0]
                }
                guard let contactEmail = contactEmail else {
                    continue
                }
                let queryContact = self.database.child("User").queryOrdered(byChild: "email").queryEqual(toValue: contactEmail)
                queryContact.observeSingleEvent(of: .value, with: {snapshotUser in
                    if let dic = snapshotUser.value as? NSDictionary {
                        for (_, v) in dic {
                            guard let value = v as? NSDictionary, let id = value["id"] as? String else {
                                continue
                            }
                            let name = value["name"] as? String ?? ""
                            let email = value["email"] as? String ?? ""
                            let textColor = value["color"] as? String ?? ""
                            let status = value["status"] as? String ?? ""
                            users.append(ChatAppUser(id: id, name: name, emailAddress: email, color: textColor, status: status))
                            completion(users)
                        }
                    }
                })
            }
            
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

//MARK: Find chats

extension DatabaseManager {
    
    private func setUserKey(for users: String, at time: String, completion: @escaping (String)->Void) {
        let query = database.child("UsersKey").queryOrdered(byChild: "users").queryEqual(toValue: users)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            guard let dic = snapshot.value as? NSDictionary else {
                let key = generateKey()
                self.saveUserKey(for: users, key: key, at: time)
                completion(key)
                return
            }
            for (k, v) in dic {
                guard let value = v as? NSDictionary, let key = value["KEY"] as? String, let uid = k as? String else {
                    continue
                }
                let obj = ["KEY": key, "Time": time, "users": users]
                self.updateUserKey(for: uid, to: obj)
                completion(key)
                return
            }
            let key = generateKey()
            self.saveUserKey(for: users, key: key, at: time)
            completion(key)
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    private func saveUserKey(for users: String, key: String, at time: String) {
        guard let uid = database.child("UsersKey").childByAutoId().key else {
            print("ОШИБКА ПОЛУЧЕНИЯ ID UsersKey!")
            return
        }
        let usersKey = ["KEY": key, "users": users, "Time": time]
        database.child("UsersKey").child(uid).setValue(usersKey)
    }
    
    private func updateUserKey(for uid: String, to data: [String: String]) {
        database.child("UsersKey").updateChildValues(["\(uid)": data])
    }
    
    private func getUserKey(for users: String, completion: @escaping (String)->Void) {
        let query = database.child("UsersKey").queryOrdered(byChild: "users").queryEqual(toValue: users)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            guard let dic = snapshot.value as? NSDictionary else {
                completion("")
                return
            }
            for (_, v) in dic {
                guard let value = v as? NSDictionary, let key = value["KEY"] as? String else {
                    continue
                }
                completion(key)
                return
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
}

//MARK: save message
extension DatabaseManager {
    
    public func saveMessage(message: String, recipient: String, completion: @escaping (Bool)->Void) {
        guard let userEmail = UserDefaults.standard.string(forKey: "email") else {
            completion(false)
            return
        }
        let arr = [recipient, userEmail].sorted(by: <)
        let users = String("\(arr[0]) \(arr[1])")
        let time = getCurTime()
        self.setUserKey(for: users, at: time, completion: { key in
            guard let uid = self.database.child("Messages").childByAutoId().key else {
                print("ОШИБКА ПОЛУЧЕНИЯ ID UsersKey!")
                completion(false)
                return
            }
            let crypt = crypt(message: message, key: key)
            self.sharedKey = key
            let saveMessage = ["Message": crypt, "Sender": userEmail, "SenderRecipient": users, "time": time]
            self.database.child("Messages").child(uid).setValue(saveMessage)
            completion(true)
        })
    }
    
    public func loadMessages(recipient: String, completion: @escaping ([MessageModel])->Void) {
        var messages = [MessageModel]()
        
        guard let userEmail = UserDefaults.standard.string(forKey: "email") else {
            completion(messages)
            return
        }
        let arr = [recipient, userEmail].sorted(by: <)
        let users = String("\(arr[0]) \(arr[1])")
        
        self.getUserKey(for: users, completion: { key in
            let query = self.database.child("Messages").queryOrdered(byChild: "SenderRecipient").queryEqual(toValue: users) //
            query.observe(.value, with: {snapshot in
                guard let dic = snapshot.value as? NSDictionary else {
                    completion(messages)
                    return
                }
                for (k, v) in dic {
                    guard let value = v as? NSDictionary, let mid = k as? String else {
                        continue
                    }
                    let text = value["Message"] as? String ?? ""
                    let sender = value["Sender"] as? String ?? ""
                    let time = value["time"] as? String ?? ""
                    let decrypt = decrypt(message: text, key: key != "" ? key: self.sharedKey)
                    let mes = MessageModel(id: mid, text: decrypt, sender: sender, time: time)
                    messages.append(mes)
                }
                completion(messages.sorted{ $0.time < $1.time })
            }) { error in
                print(error.localizedDescription)
            }
        })
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

