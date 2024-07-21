//
//  HomeViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 7.07.24.
//

import UIKit

class HomeViewController: UIViewController {
    
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
        
        view.addSubview(timelineTableView)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
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
    
    @objc private func didTapProfile() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
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
