//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 19.12.2022.
//

import UIKit

class FavoriteCell: UITableViewCell {
  
  static let reuseID = "FavoriteCell"
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTittleLabel(textAlignment: .left, fontSize: 26)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(Favorite: Follower) {
    usernameLabel.text = Favorite.login
    avatarImageView.downloadAvatarImage(url: Favorite.avatarUrl)
  }
  
  private func configure() {
    addSubViews(avatarImageView, usernameLabel)
    
    accessoryType = .disclosureIndicator
    let padding: CGFloat = 12
    
    NSLayoutConstraint.activate([
      avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      avatarImageView.heightAnchor.constraint(equalToConstant: 60),
      avatarImageView.widthAnchor.constraint(equalToConstant: 60),
      
      usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
      usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      usernameLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}
