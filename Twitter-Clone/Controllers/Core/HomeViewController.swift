//
//  HomeViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 7.07.24.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var composeTwitterButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            self?.navigateToTweetCompose()
        }))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()
    
    private let timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogoutButton))
        navigationItem.rightBarButtonItem?.tintColor = .link
        
        view.addSubview(timelineTableView)
        view.addSubview(composeTwitterButton)
        configureNavigationBar()
        configureConstraints()
        
        bindViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retrieveUser()
        
    }
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else {return}
            if !user.isUserOnboarded {
                self?.completeUserOnboarding()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        let composeTwitterButtonConstraints = [
            composeTwitterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTwitterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composeTwitterButton.widthAnchor.constraint(equalToConstant: 60),
            composeTwitterButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(composeTwitterButtonConstraints)
    }
    
    private func navigateToTweetCompose() {
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    private func completeUserOnboarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    private func configureNavigationBar() {
       
        let imageSize: CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitterLogo")
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        logoView.addSubview(logoImageView)
        
        navigationItem.titleView = logoView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
        
        navigationController?.navigationBar.tintColor = .label
    
    }
    
    @objc private func didTapLogoutButton() {
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    @objc private func didTapProfile() {
        guard let user = viewModel.user else {return}
        let profileVM = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileVM)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
        
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.configureTweetCell(username: tweetModel.author.username,
                                displayName: tweetModel.author.displayName,
                                tweetContent: tweetModel.tweetContent,
                                avatarPath: tweetModel.author.avatarPath)
        
        return cell
    }
    
    
}


extension HomeViewController: TweetTableViewCellDelegate {
    
    func tweetTableViewCellDidTapReply() {
        print("reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("retweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("share")
    }
    
    
}
