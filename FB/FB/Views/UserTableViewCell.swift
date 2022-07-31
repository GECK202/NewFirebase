//
//  UserTableViewCell.swift
//  FB
//
//  Created by Valeria Karon on 7/30/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
  
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "BaseColor")
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        return label
    }()
    
    private let userStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userStatusLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)
        
        userNameLabel.frame = CGRect(x: userImageView.right + 10,
                                     y: 10,
                                     width: contentView.width - 20 - userImageView.width,
                                     height: (contentView.height-20)/2)
        
        userStatusLabel.frame = CGRect(x: userImageView.right + 10,
                                        y: userNameLabel.bottom + 5,
                                        width: contentView.width - 20 - userImageView.width,
                                        height: (contentView.height-20)/2)
        
    }

    public func configure(user: ChatAppUser) {
        userStatusLabel.text = user.status
        userNameLabel.text = user.name
        userImageView.tintColor = UIColor.fromUIntText(text: user.color)
    }

}
