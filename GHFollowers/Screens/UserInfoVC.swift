//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 12.12.2022.
//

import UIKit

protocol UserInfoVCCDelegate: AnyObject {
  func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
  
  let scrollView = UIScrollView()
  let contentView = UIView()
  
  let headerView = UIView()
  let itemViewOne = UIView()
  let itemValueTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  
  var itemsViews: [UIView] = []
  
  var username: String!
  weak var delegate: UserInfoVCCDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    getUserInfo()
    layOutUI()
    configureScrollView()
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.pinToEdges(superView: view)
    contentView.pinToEdges(superView: scrollView)
    
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 600)
    ])
  }
  
  func getUserInfo() {
    Task {
      do {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        configureUIElements(user: user)
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
        } else {
          presentDefaultError()
        }
      }
    }
  }
  
  func configureUIElements(user: User) {
    
    let repoItemVC = GFRepoItemVC(user: user, delegate: self)
    
    let followerItemVC = GFFollowerItemVC(user: user, delegate: self)
    followerItemVC.delegate = self
    
    
    self.add(childVC: GFUserInfoHeaderVC(user: user), containerView: self.headerView)
    self.add(childVC: repoItemVC, containerView: self.itemViewOne)
    self.add(childVC: followerItemVC, containerView: self.itemValueTwo)
    self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormatter())"
  }
  
  func layOutUI() {
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
    itemsViews = [headerView, itemViewOne, itemValueTwo, dateLabel]
    
    for itemView in itemsViews {
      contentView.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
      ])
    }
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 210),
      
      itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
      
      itemValueTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemValueTwo.heightAnchor.constraint(equalToConstant: itemHeight),
      
      dateLabel.topAnchor.constraint(equalTo: itemValueTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 50)
      
    ])
  }
  
  func add(childVC: UIViewController, containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
  
  @objc func dismissVC() {
    dismiss(animated: true, completion: nil)
  }
}

extension UserInfoVC: GFRepoItemVCDelegate {
  func didTapGitHubProfile(for user: User) {
    guard let url = URL(string: user.htmlUrl) else{
      presentGFAlert(title: "Invalid URL", message: "The URL attached to this user is invalid", buttonTitle: "Ok")
      return
    }
    presentSafariVC(with: url)
  }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
  func didTapGitHubFollowers(for user: User) {
    guard user.followers != 0 else {
      presentGFAlert(title: "No followers", message: "This user has no followers. What a shame 😞", buttonTitle: "Ok")
      return
    }
    delegate.didRequestFollowers(for: user.login)
    dismissVC()
  }
}
