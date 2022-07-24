//
//  RegisterViewController.swift
//  MyFirstFirebaseProject
//
//  Created by Valeria Karon on 7/11/22.
//  Copyright © 2022 Valeria Karon. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.keyboardType = UIKeyboardType.emailAddress
        field.layer.cornerRadius = 20
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Введите email..."
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        let imageView = UIImageView(image: UIImage(systemName: "envelope"))
        imageView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        someView.addSubview(imageView)
        field.leftView = someView
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 20
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Введите пароль..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        //field.isSecureTextEntry = true
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        let imageView = UIImageView(image: UIImage(systemName: "lock"))
        imageView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        someView.addSubview(imageView)
        field.leftView = someView
        return field
    }()
    
    private let userField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 20
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Введите имя..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        someView.addSubview(imageView)
        field.leftView = someView
        return field
    }()
    
    private let RegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = UIColor(named: "BaseColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        view.backgroundColor = .systemBackground
        
        
        emailField.delegate = self
        passwordField.delegate = self
        userField.delegate = self
        
        RegisterButton.addTarget(
            self,
            action: #selector(RegisterButtonTapped),
            for: .touchUpInside
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(userField)
        scrollView.addSubview(RegisterButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let v_space: CGFloat = 30
        let h_space: CGFloat = 60
        let left_space: CGFloat = 30
        let h_item: CGFloat = 52
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: v_space,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: left_space,
                                  y: imageView.bottom+v_space,
                                  width: scrollView.width-h_space,
                                  height: h_item)
        passwordField.frame = CGRect(x: left_space,
                                     y: emailField.bottom+v_space,
                                     width: scrollView.width-h_space,
                                     height: h_item)
        userField.frame = CGRect(x: left_space,
                                 y: passwordField.bottom+v_space,
                                 width: scrollView.width-h_space,
                                 height: h_item)
        RegisterButton.frame = CGRect(x: left_space,
                                      y: userField.bottom+v_space,
                                      width: scrollView.width-h_space,
                                      height: h_item)
    }
    
    @objc private func RegisterButtonTapped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        userField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, let user = userField.text,
            !email.isEmpty, !password.isEmpty, password.count >= 6, !user.isEmpty else {
                alertUserRegisterError()
                return
        }
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard authResult != nil, error == nil else {
                print("Ошибка создания пользователя")
                if let error = error as NSError?, error.code == 17007 {
                    strongSelf.alertUserRegisterError(message: "Пользователь с email \(email) уже зарегистрирован!")
                }
                return
            }
            let uid = Auth.auth().currentUser?.uid ?? ""
            let user = ChatAppUser(id: uid, name: user, emailAddress: email, color: String(UIColor.random().toUInt), status: "no status")
            
            DatabaseManager.shared.insertUser(with: user)
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func alertUserRegisterError(message: String = "Заполните все поля для авторизации!\nПароль не менее 6 символов!") {
        let alert = UIAlertController(title: "Уупс...",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Закрыть",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            userField.becomeFirstResponder()
        }
        else if textField == userField {
            RegisterButtonTapped()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor(named: "BaseColor")?.cgColor
        textField.layer.borderWidth = 2
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        
    }
    
}

