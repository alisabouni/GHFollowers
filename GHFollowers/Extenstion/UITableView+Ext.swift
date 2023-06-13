//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 20.12.2022.
//

import UIKit

extension UITableView {
  
  func reloadDataOnMainThread() {
    DispatchQueue.main.async { self.reloadData() }
  }
  
  func removeExcessCell() {
    tableFooterView = UIView(frame: .zero)
  }
}
