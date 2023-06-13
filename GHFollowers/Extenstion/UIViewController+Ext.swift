//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 9.12.2022.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
  
  func presentGFAlert(title: String, message: String, buttonTitle: String) {
    let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    present(alertVC, animated: true)
  }
  
  func presentDefaultError() {
    let alertVC = GFAlertVC(alertTitle: "Something went wrong",
                            message: "We were unable to complete your task at this time please try again.",
                            buttonTitle: "Ok")
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    present(alertVC, animated: true)
  }
  
  func presentSafariVC(with url: URL) {
    let safariVC = SFSafariViewController(url: url)
    safariVC.preferredControlTintColor = .systemGreen
    present(safariVC, animated: true)
  }
}
