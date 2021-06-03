//
//  CustomTextField.swift
//  QuizApp
//
//  Created by five on 28.05.2021..
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.3)
        attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.3)])
        layer.borderWidth = 0
        layer.borderColor = CGColor(gray: 1, alpha: 1)
        layer.cornerRadius = frame.height/2
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height/2, height: frame.height))
        leftViewMode = .always
        delegate = self
    }
    
    func setPlaceholderText(_ placeholderText: String) {
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.3)])
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: radius, height: radius*2))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderWidth = 0
    }
}
