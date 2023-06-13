//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 19.12.2022.
//

import UIKit

class GFDataLoadingVC: UIViewController {
  
  var containerView: UIView!
  
  func showLoadingView() {
    containerView = UIView(frame: view.bounds) // whole screen
    view.addSubview(containerView)
    
    containerView.backgroundColor = .systemBackground
    containerView.alpha = 0 // transparentcy
    
    UIView.animate(withDuration: 0.25) {  // add the animation
      self.containerView.alpha = 0.8
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    containerView.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    // constraints
    NSLayoutConstraint.activate([
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
    ])
    
    activityIndicator.startAnimating()
  }
  
  func dismissLoadingView() {
    DispatchQueue.main.async {
      self.containerView.removeFromSuperview()
      self.containerView = nil
    }
  }
  
  func showEmptyStateView(message: String, view: UIView) {
    let emptyStateView = GFEmptyStateView(message: message)
    emptyStateView.frame = view.bounds
    view.addSubview(emptyStateView)
  }
}
