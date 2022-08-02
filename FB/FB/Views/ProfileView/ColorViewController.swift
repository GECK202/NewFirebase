//
//  ColorViewController.swift
//  FB
//
//  Created by Valeria Karon on 7/31/22.
//

import UIKit
import Colorful

class ColorViewController: UIViewController {

    public var userColor:UIColor = .red
    
    public var colorAction: ((String)->Void)?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let colorPicker:ColorPicker = {
        let picker = ColorPicker()
        return picker
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.backgroundColor = UIColor(named: "BaseColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.backgroundColor = .darkGray
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ColorPicker start")
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BaseColor")
        
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.TextStyle.largeTitle]
        if let navFont = UIFont(name: "HelveticaNeue", size: 25.0) {
            let navBarAttributesDictionary: [NSAttributedString.Key: AnyObject]? = [NSAttributedString.Key.font: navFont, NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        selectButton.addTarget(
            self,
            action: #selector(selectButtonTapped),
            for: .touchUpInside
        )
        
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        colorPicker.set(color: userColor, colorSpace: HRColorSpace.extendedSRGB)
        
        view.addSubview(scrollView)
        scrollView.addSubview(colorPicker)
        scrollView.addSubview(selectButton)
        scrollView.addSubview(cancelButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width
        colorPicker.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 0,
                                 width: size-30,
                                 height: size-30)
        
        selectButton.frame = CGRect(x: 20,
                                   y: colorPicker.bottom+20,
                                   width: scrollView.width-40,
                                   height: 52)
        
        cancelButton.frame = CGRect(x: 20,
                                   y: selectButton.bottom+20,
                                   width: scrollView.width-40,
                                   height: 52)
    }

    @objc private func cancelButtonTapped() {
        print("color picker back")
        self.navigationController?.dismiss(animated: false, completion: nil)
    }

    @objc private func selectButtonTapped(){
        guard let action = self.colorAction else {
            return
        }
        action(String(colorPicker.color.toUInt))
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
}
