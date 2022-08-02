//
//  ProfileViewCell.swift
//  FB
//
//  Created by Valeria Karon on 7/30/22.
//

import UIKit

class ProfileViewCell: UITableViewCell {
  
    static let identifier = "profile"
    
    private var inputAction: ((String)->Void)?
    
    private var colorAction: (()->Void)?
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        imageView.bounds = CGRect(x: 0, y: 0, width: 140, height: 140)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    private let userNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.font = .systemFont(ofSize: 26, weight: .semibold)
        field.layer.borderColor = UIColor(named: "BaseColor")?.cgColor
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userNameField.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [
            userImageView,
            emailLabel,
            userNameLabel,
            userNameField])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        contentView.addSubview(stackView)
        
        userImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 100, paddingRight: 50, width: 100, height: 100, enableInsets: false)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 240, enableInsets: false)
        
        userNameField.addTarget(self, action: #selector(userNameFieldDidChange(textField:)), for: .editingChanged)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:)))
            userImageView.isUserInteractionEnabled = true
            userImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func userNameFieldDidChange(textField: UITextField) {
        guard let action = self.inputAction else {
            return
        }
        action(textField.text ?? "no name")
    }
    
    @objc private func imageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        print("image tap")
        guard let action = self.colorAction else {
            return
        }
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(user: ChatAppUser, inputAction: @escaping (String)->Void, colorAction: @escaping ()->Void) {
        userNameField.text = user.name
        userNameLabel.text = "Имя"
        emailLabel.text = user.emailAddress
        userImageView.tintColor = UIColor.fromUIntText(text: user.color)
        self.inputAction = inputAction
        self.colorAction = colorAction
    }
}


extension ProfileViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameField {
            emailLabel.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
