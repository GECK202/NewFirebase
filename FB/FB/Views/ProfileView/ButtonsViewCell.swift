//
//  ButtonsViewCell.swift
//  FB
//
//  Created by Valeria Karon on 7/31/22.
//

import UIKit

class ButtonsViewCell: UITableViewCell {
    
    static let identifier = "buttons"
    
    var saveAction: (()->Void)?
    
    var logOutAction: (()->Void)?
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 107/256, blue: 0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = UIColor(red: 190/256, green: 0, blue: 0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [
            saveButton,
            logOutButton])
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        contentView.addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 35, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 50, enableInsets: false)
        
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutButtonTap), for: .touchUpInside)
    }
    
    @objc private func saveButtonTap() {
        guard let action = self.saveAction else {
            return
        }
        action()
    }
    
    @objc private func logOutButtonTap() {
        guard let action = self.logOutAction else {
            return
        }
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func configure(saveAction: @escaping ()->Void, logOutAction: @escaping ()->Void){
        self.saveAction = saveAction
        self.logOutAction = logOutAction
    }
}
