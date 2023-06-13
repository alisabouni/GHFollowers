//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 9.12.2022.
//

import UIKit

class GFAvatarImageView: UIImageView {
  
  let cache = NetworkManager.shared.cache
  let placeHolderImage = Images.placeholder
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    layer.cornerRadius = 10
    clipsToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
    image = placeHolderImage
  }
  
  func downloadAvatarImage(url: String) {
    Task { image = await NetworkManager.shared.downloadImage(from: url) ?? placeHolderImage }
  }
}
