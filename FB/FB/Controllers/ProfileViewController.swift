//
//  ProfileViewController.swift
//  FB
//
//  Created by Valeria Karon on 7/27/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private var profileData = [ProfileCellViewModel]()
    private var user: ChatAppUser?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileViewCell.self,
                           forCellReuseIdentifier: ProfileViewCell.identifier)
        tableView.register(StatusViewCell.self,
                           forCellReuseIdentifier: StatusViewCell.identifier)
        tableView.register(ButtonsViewCell.self,
                           forCellReuseIdentifier: ButtonsViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        setProfileData()
    }
    
   /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
    }
    */
    
    
    private func setProfileData() {
        //print(Auth.auth().currentUser?.uid)
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Неизвестная ошибка!")
            return
        }
        DatabaseManager.shared.getUser(with: uid, completion: {[weak self] user in
            guard let strongSelf = self else {
                return
            }
            strongSelf.user = user
            strongSelf.profileData.removeAll()
            strongSelf.profileData.append(
                ProfileCellViewModel(type: .info,
                                     height: 250,
                                     cellIdentifier: ProfileViewCell.identifier))
            strongSelf.profileData.append(
                ProfileCellViewModel(type: .status,
                                     height: 100,
                                     cellIdentifier: StatusViewCell.identifier))
            strongSelf.profileData.append(
                ProfileCellViewModel(type: .buttons,
                                     height: 80,
                                     cellIdentifier: ButtonsViewCell.identifier))
                                     
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    private func colorAction() {
        print("color action")
        let vc = ColorViewController()
        if let textColor = user?.color {
            vc.userColor = UIColor.fromUIntText(text: textColor)
        }
        vc.colorAction = { result in
            
            
            self.user = ChatAppUser(id: self.user!.id, name: self.user!.name, emailAddress: self.user!.emailAddress, color: result, status: self.user!.status)
            
            print("picker result=\(result) user = \(self.user)")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        vc.title = "Цвет аватара"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    private func saveAction() {
        DatabaseManager.shared.insertUser(with: self.user!, competition: { isSave in
            if isSave == true {
                let actionSheet = UIAlertController(title: "Изменения сохранены",
                                                    message: "",
                                                    preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Закрыть",
                                                    style: .cancel,
                                                    handler: nil))
                self.present(actionSheet, animated: true)
            } else {
                let actionSheet = UIAlertController(title: "Изменения не сохранены!",
                                                    message: "",
                                                    preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Закрыть",
                                                    style: .cancel,
                                                    handler: nil))
                self.present(actionSheet, animated: true)
            }
        })
    }
    
    private func logOutAction() {
        
        let actionSheet = UIAlertController(title: "Сменить профиль",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Выход",
                                            style: .destructive,
                                            handler: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: false)
            } catch {
                print("Ошибка выхода!")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Отмена",
                                            style: .cancel,
                                            handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    func createTableHeader()->UIView? {
        let view = UIView()
        return view
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath) as! ProfileViewCell
            cell.configure(user: user!, inputAction: { [self] result in
                self.user = ChatAppUser(id: self.user!.id, name: result, emailAddress: self.user!.emailAddress, color: self.user!.color, status: self.user!.status)
            }, colorAction: colorAction)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "status", for: indexPath) as! StatusViewCell
            cell.configure(user: user!, action: { [self] result in
                self.user = ChatAppUser(id: self.user!.id, name: self.user!.name, emailAddress: self.user!.emailAddress, color: self.user!.color, status: result)
                print("\(String(describing: self.user))")
            })
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttons", for: indexPath) as! ButtonsViewCell
            cell.configure(saveAction: self.saveAction, logOutAction: self.logOutAction)
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileData[indexPath.row].height
    }
}
