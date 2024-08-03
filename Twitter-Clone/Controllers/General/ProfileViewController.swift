//
//  ProfileViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 15.07.24.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var viewModel: ProfileViewViewModel
    
    init(viewModel: ProfileViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var isStatusBarHidden: Bool = true
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 390))
    
    private var statusBar: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private var profileTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        configureConstraints()
        
        bindViews()
        
        viewModel.fetchUserTweets()
    }
        
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
         
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.usernameLabel.text = "@\(user.username)"
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.joinDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with: user.createdOn) ?? "")"
        }
        .store(in: &subscriptions )
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
           
        }
        .store(in: &subscriptions)
        
        viewModel.$currentFollowingState.sink { [weak self] followingState in
            switch followingState {
            case .personal:
                self?.headerView.configureButtonAsPersonal()
            case .userIsFollowed:
                self?.headerView.configureButtonAsUnfollow()
            case .userIsNotFollowed:
                self?.headerView.configureButtonAsFollow()
            }
        }
        .store(in: &subscriptions)
    }
    
    
    private func configureConstraints() {
        
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraints = [
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
    

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell()}
        
        let tweet = viewModel.tweets[indexPath.row]
        cell.configureTweetCell(username: tweet.author.username, displayName: tweet.author.displayName, tweetContent: tweet.tweetContent, avatarPath: tweet.author.avatarPath)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
    
    
}
