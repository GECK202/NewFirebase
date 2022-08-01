//
//  ViewController.swift
//  FB
//
//  Created by Valeria Karon on 7/27/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    private var userList = [ChatAppUser]()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UserTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.show(in: view)
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        setupTableView()
        
    }
    
    private func startListeningForUsers() {

        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        print("starting conversation fetch...")
        
        DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
            if result.count == 0 {
                self?.tableView.isHidden = true
                self?.noConversationsLabel.isHidden = false
                print("нет данных")
            } else {
                self?.noConversationsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.userList = result

                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                    self?.tableView.reloadData()
                }
            }
        })
        
    }
    

    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationsLabel.frame = CGRect(x: 10,
                                            y: (view.height-100)/2,
                                            width: view.width-20,
                                            height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        getAllUsers()
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

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations() {
        tableView.isHidden = false
    }
    
    private func getAllUsers() {
        startListeningForUsers()
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.startListeningForUsers()
        })
    }
        
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath) as! UserTableViewCell
        cell.configure(user: userList[indexPath.row].self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = userList[indexPath.row].name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

