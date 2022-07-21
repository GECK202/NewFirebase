//
//  File.swift
//  MyFirstFirebaseProject
//
//  Created by Valeria Karon on 7/11/22.
//  Copyright © 2022 Valeria Karon. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else { getUserInfo() }
    }
    
    private func getUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Неизвестная ошибка!")
            return
        }
        DatabaseManager.shared.getUser(with: uid, completion: {[weak self] user in
            guard let strongSelf = self else {
                return
            }
            
            let col = UIColor.fromUIntText(text: user.color)
            strongSelf.view.backgroundColor = col
            print ("name-\(user.name) color-\(col) email-\(user.emailAddress)")
            
        })
    }


}
