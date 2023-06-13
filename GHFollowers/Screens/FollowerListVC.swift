//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 5.12.2022.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
  
  enum Section { case main }
  
  var username: String!
  var followers: [Follower] = []
  var filteredFollowers: [Follower] = []
  var page = 1
  var hasMoreFollowers = true
  var isSearching = false
  var isLoadingMoreFollowers = false
  
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  init(username: String) {
    super.init(nibName: nil, bundle: nil)
    self.username = username
    title = username
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
    configureCollectionView()
    getFollowers(username: username, page: page)
    configureDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton
  }
  
  func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }
  
  func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Search for a username"
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    
  }
  
  func getFollowers(username: String, page: Int) {
    showLoadingView()
    isLoadingMoreFollowers = true
    Task {
      do {
        let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
        update(with: followers)
        dismissLoadingView()
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Bad Stuff Happened", message: gfError.rawValue, buttonTitle: "Ok")
        } else {
          presentDefaultError()
        }
        dismissLoadingView()
      }
      isLoadingMoreFollowers = false
    }
  }
  
  func update(with followers: [Follower]) {
    if followers.count < 100 { self.hasMoreFollowers = false}
    self.followers.append(contentsOf: followers)
    if self.followers.isEmpty {
      let message = "This user doesn't have any followers. Go follow them 😃."
      DispatchQueue.main.async {
        self.showEmptyStateView(message: message, view: self.view)
      }
      return
    }
    self.updateData(followers: self.followers)
  }
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
      cell.set(follower: follower)
      return cell
    })
  }
  
  func updateData(followers: [Follower]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
  @objc func addButtonTapped() {
    showLoadingView()
    Task {
      do {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        addUserToFavorites(user: user)
        dismissLoadingView()
      } catch {
        if let gfError = error as? GFError {
          presentGFAlert(title: "Something want wrong", message: gfError.rawValue, buttonTitle: "Ok")
        } else {
          presentDefaultError()
        }
        dismissLoadingView()
      }
    }
  }
  
  func addUserToFavorites(user: User) {
    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
    
    PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
      guard let self else { return }
      guard let error else {
        DispatchQueue.main.async {
          self.presentGFAlert(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
        }
        return
      }
      DispatchQueue.main.async {
        self.presentGFAlert(title: "Something want wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
}

extension FollowerListVC: UICollectionViewDelegate {
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height
    
    if offsetY > contentHeight - height {
      guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let activeArray = isSearching ? filteredFollowers : followers
    let follower = activeArray[indexPath.item]
    
    let destVC = UserInfoVC()
    destVC.username = follower.login
    destVC.delegate = self
    let navController = UINavigationController(rootViewController: destVC)
    present(navController, animated: true)
  }
}

extension FollowerListVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
      filteredFollowers.removeAll()
      isSearching = false
      updateData(followers: followers)
      return
    }
    isSearching = true
    filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
    updateData(followers: filteredFollowers)
  }
}

extension FollowerListVC: UserInfoVCCDelegate {
  func didRequestFollowers(for username: String) {
    self.username = username
    title = username
    page = 1
    followers.removeAll()
    filteredFollowers.removeAll()
    updateData(followers: followers)
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    getFollowers(username: username, page: page)
  }
}