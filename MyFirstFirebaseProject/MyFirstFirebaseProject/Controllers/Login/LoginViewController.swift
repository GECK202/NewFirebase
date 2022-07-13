//
//  ViewController.swift
//  MyFirstFirebaseProject
//
//  Created by Valeria Karon on 7/11/22.
//  Copyright © 2022 Valeria Karon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        field.isSecureTextEntry = true
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        let imageView = UIImageView(image: UIImage(systemName: "lock"))
        imageView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        someView.addSubview(imageView)
        field.leftView = someView
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor(named: "BaseColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Авторизация"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Регистрация",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        emailField.delegate = self
        passwordField.delegate = self
        
        loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
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
        loginButton.frame = CGRect(x: left_space,
                                   y: passwordField.bottom+v_space,
                                   width: scrollView.width-h_space,
                                   height: h_item)
    }
    
    @objc private func loginButtonTapped(){
        guard let email = emailField.text, let password = passwordField.text,
            !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        print("OK")
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Уупс...",
                                      message: "Пожалуйста, заполните все поля для входа.\nДлина пароля не менее 6 символов",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Закрыть",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
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
