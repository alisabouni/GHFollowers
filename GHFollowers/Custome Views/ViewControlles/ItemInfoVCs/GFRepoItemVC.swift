//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 16.12.2022.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
  func didTapGitHubProfile(for user: User)
}
class GFRepoItemVC: GFItemInfoVC {
  
  weak var delegate: GFRepoItemVCDelegate!
  
  init(user: User, delegate: GFRepoItemVCDelegate) {
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
    itemInfoViewOne.set(ItemInfoType: .repos, count: user.publicRepos)
    itemInfoViewTwo.set(ItemInfoType: .gists, count: user.publicGists)
    actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
  }
  
  override func actionButtonTapped() {
    delegate.didTapGitHubProfile(for: user)
  }
}
