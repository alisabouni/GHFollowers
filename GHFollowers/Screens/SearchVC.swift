//
//  SearchVC.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 4.12.2022.
//

import UIKit

class SearchVC: UIViewController {
  
  let logoImageView = UIImageView()
  let usernameTextField = GFTextField()
  let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
  
  var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubViews(logoImageView, usernameTextField, callToActionButton)
    configureLogoImageView()
    configureTextFiled()
    configureCallToActionButton()
    createDismissKeyboardTapGesture()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    usernameTextField.text = ""
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func createDismissKeyboardTapGesture() {
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }
  
  @objc func pushFollowersListVC() {
    
    guard isUsernameEntered else {
      presentGFAlert(title: "Empty Username", message: "Please enter a username, we need to know who to look for 😀.", buttonTitle: "Ok")
      return
    }
    
    usernameTextField.resignFirstResponder()
    
    let followersListVC = FollowerListVC(username: usernameTextField.text!)
    navigationController?.pushViewController(followersListVC, animated: true)
  }
  
  
  func configureLogoImageView() {
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.image = Images.ghLogo
    
    let topConstraintContent: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 15 : 80
    
    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintContent),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.heightAnchor.constraint(equalToConstant: 200),
      logoImageView.widthAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  func configureTextFiled() {
    usernameTextField.delegate = self
    
    NSLayoutConstraint.activate([
      usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
      usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      usernameTextField.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  func configureCallToActionButton() {
    callToActionButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      callToActionButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
}

extension SearchVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    pushFollowersListVC()
    return true
  }
}
