//
//  GFItemsInfoView.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 16.12.2022.
//

import UIKit

enum ItemInfoType {
  case repos, gists, followers, following
}

class GFItemsInfoView: UIView {
  
  let symbolImageView = UIImageView()
  let titleLabel = GFTittleLabel(textAlignment: .left, fontSize: 14)
  let countLabel = GFTittleLabel(textAlignment: .center, fontSize: 14)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    addSubViews(symbolImageView, titleLabel, countLabel)
    
    symbolImageView.translatesAutoresizingMaskIntoConstraints = false
    symbolImageView.contentMode = .scaleAspectFill
    symbolImageView.tintColor = .label
    
    NSLayoutConstraint.activate([
      symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
      symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      symbolImageView.widthAnchor.constraint(equalToConstant: 20),
      symbolImageView.heightAnchor.constraint(equalToConstant: 20),
      
      titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 18),
      
      countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
      countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      countLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }
  
  func set(ItemInfoType: ItemInfoType, count: Int) {
    
    switch ItemInfoType {
      
    case .repos:
      symbolImageView.image = SFSymbols.repos
      titleLabel.text = "Public Repos"
      
    case .gists:
      symbolImageView.image = SFSymbols.gists
      titleLabel.text = "Public gists"
      
    case .followers:
      symbolImageView.image = SFSymbols.follwers
      titleLabel.text = "Followers"
      
    case .following:
      symbolImageView.image = SFSymbols.following
      titleLabel.text = "Following"
    }
    
    countLabel.text = String(count)
  }
}
