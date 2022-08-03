//
//  NewConversationViewController.swift
//  FB
//
//  Created by Valeria Karon on 7/27/22.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {

    public var completion: ((SearchResult) -> (Void))?

    private let spinner = JGProgressHUD(style: .dark)

    private var userList = [ChatAppUser]()

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        table.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func findUsers(findString: String) {
        self.spinner.show(in: self.view)
        DatabaseManager.shared.findUsers(findString: findString, completion: { [weak self] result in
            self?.userList = result
            DispatchQueue.main.async {
                self?.spinner.dismiss()
                self?.tableView.reloadData()
            }
        })
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userList.count == 0 {
            return 2
        } else {
            return userList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier, for: indexPath) as! SearchViewCell
            cell.configure(action: self.findUsers)
            cell.selectionStyle = .none
            return cell
        } else {
            if userList.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "Пользователи не найдены!"
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
                cell.configure(user: userList[indexPath.row - 1].self, viewStatus: false)
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row > 0) && (userList.count > 0) {
            let vc = ChatViewController()
            vc.title = userList[indexPath.row - 1].name
            vc.configure(recipient: userList[indexPath.row - 1])
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 110
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
