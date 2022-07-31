//
//  StatusViewCell.swift
//  FB
//
//  Created by Valeria Karon on 7/31/22.
//

import UIKit

class StatusViewCell: UITableViewCell {
    
    static let identifier = "status"
    
    var action: ((String)->Void)?
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    private let statusField: UITextField = {
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
            statusLabel,
            statusField])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        contentView.addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 90, enableInsets: false)
        
        statusField.addTarget(self, action: #selector(TextDidChanged), for: UIControl.Event.editingDidEnd)
        
    }
    
    @objc private func TextDidChanged(){
        guard let action = self.action else {
            return
        }
        action(statusField.text ?? "no status")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func configure(user: ChatAppUser, action: @escaping (String)->Void) {
        statusLabel.text = "Статус"
        statusField.text = user.status
        self.action = action
    }
    
}
