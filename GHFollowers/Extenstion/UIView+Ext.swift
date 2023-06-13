//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 20.12.2022.
//

import UIKit

extension UIView {
  
  func pinToEdges(superView: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superView.topAnchor),
      leadingAnchor.constraint(equalTo: superView.leadingAnchor),
      trailingAnchor.constraint(equalTo: superView.trailingAnchor),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor)
    ])
  }
  
  func addSubViews(_ views: UIView...) {
    for view in views { addSubview(view) }
  }
}
