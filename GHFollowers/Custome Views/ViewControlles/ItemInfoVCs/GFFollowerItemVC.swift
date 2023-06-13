//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 16.12.2022.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
  func didTapGitHubFollowers(for user: User)
}
class GFFollowerItemVC: GFItemInfoVC {
  
  weak var delegate: GFFollowerItemVCDelegate!
  
  init(user: User, delegate: GFFollowerItemVCDelegate) {
    super.init(user: user)
    self.delegate = delegate
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(ItemInfoType: .followers, count: user.followers)
    itemInfoViewTwo.set(ItemInfoType: .following, count: user.following)
    actionButton.set(color: .systemGreen, title: "Get Follower", systemImageName: "person.3")
  }
  
  override func actionButtonTapped() {
    delegate.didTapGitHubFollowers(for: user)
  }
}
