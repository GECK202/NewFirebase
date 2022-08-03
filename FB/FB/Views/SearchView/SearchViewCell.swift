//
//  SearchViewCell.swift
//  FB
//
//  Created by Valeria Karon on 8/2/22.
//

import UIKit

class SearchViewCell: UITableViewCell {

    static let identifier = "search"
    
    var searchAction: ((String)->Void)?
    
    private let searchField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 20
        field.layer.masksToBounds = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        return field
    }()
    
    private let findImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        searchField.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [
            searchField,
            findImageView])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        contentView.addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 50, enableInsets: false)
        
        searchField.addTarget(self, action: #selector(searchFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc private func searchFieldDidChange(textField: UITextField) {
        guard let action = self.searchAction, let findText = textField.text else {//}, findText != "" else {
            return
        }
        action(findText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(action: @escaping (String)->Void){
        self.searchAction = action
        self.searchField.becomeFirstResponder()
    }
}

extension SearchViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.becomeFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 0.56, green: 0.18, blue: 0.74, alpha: 1.0).cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
    }
    
}
