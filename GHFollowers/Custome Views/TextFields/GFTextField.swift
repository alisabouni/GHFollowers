//
//  GFTextField.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 5.12.2022.
//

import UIKit

class GFTextField: UITextField {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    becomeFirstResponder()
    translatesAutoresizingMaskIntoConstraints = false
    
    layer.borderWidth = 2
    layer.cornerRadius = 10
    layer.borderColor = UIColor.systemGray4.cgColor
    
    textColor = .label
    tintColor = .label
    textAlignment = .center
    font = UIFont.preferredFont(forTextStyle: .title2)
    adjustsFontSizeToFitWidth = true
    minimumFontSize = 12
    
    backgroundColor = .tertiarySystemBackground
    autocorrectionType = .no
    returnKeyType = .go
    clearButtonMode = .whileEditing
    autocapitalizationType = .none
    
    placeholder = "Enter a username"
  }
  
}
