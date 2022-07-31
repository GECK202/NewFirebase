//
//  ProfileViewCell.swift
//  FB
//
//  Created by Valeria Karon on 7/30/22.
//

import UIKit

class ProfileViewCell: UITableViewCell {
  
    static let identifier = "profile"
    
    var action: ((String)->Void)?
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
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
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 240, enableInsets: false)
        
        userNameField.addTarget(self, action: #selector(TextDidChanged), for: UIControl.Event.editingDidEnd)
        
    }
    
    @objc private func TextDidChanged(){
        guard let action = self.action else {
            return
        }
        action(userNameField.text ?? "no name")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func configure(user: ChatAppUser, action: @escaping (String)->Void) {
        userNameField.text = user.name
        userNameLabel.text = "Имя"
        emailLabel.text = user.emailAddress
        userImageView.tintColor = UIColor.fromUIntText(text: user.color)
        self.action = action
    }
}
