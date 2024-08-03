//
//  ProfileHeader.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 18.07.24.
//

import UIKit
import Combine

class ProfileTableViewHeader: UIView {
    
    private enum SectionTabs: String {
        case tweets = "Tweets"
        case tweetsAndReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index:Int {
            switch self {
            case .tweets:
                return 0
            case .tweetsAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    
    private var leadingAncors: [NSLayoutConstraint] = []
    private var trailingAncors: [NSLayoutConstraint] = []
    
    private var currentFollowState: ProfileFollowingState = .personal
    var followButtonActionPublisher: PassthroughSubject<ProfileFollowingState, Never> = PassthroughSubject()
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .twitterBlueColor
        return view
    }()
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.sectionStack.subviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAncors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAncors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in
                    //
                }
                
            }
        }
    }
    
    private var tabs: [UIButton] = ["Tweets", "Tweets & Replies", "Media", "Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.tintColor = .label
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    var profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "headerImage")
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var profileAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userBioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var joinDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var followingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let followingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    var followersCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let followersTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Follow", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(displayNameLabel)
        addSubview(usernameLabel)
        addSubview(userBioLabel)
        addSubview(joinDateImageView)
        addSubview(joinDateLabel)
        addSubview(followingCountLabel)
        addSubview(followingTextLabel)
        addSubview(followersCountLabel)
        addSubview(followersTextLabel)
        addSubview(sectionStack)
        addSubview(followButton)
        addSubview(indicator)
        configureConstraints()
        configureStackButton()
        configureFollowButtonAction()
    
    }
    
    private func configureFollowButtonAction() {
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    private func configureStackButton() {
        for (i, button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else {return}
            
            if i == selectedTab {
                button.tintColor = .label
            } else {
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self, action: #selector(didTapTab), for: .touchUpInside)
        }
    }
    
    func configureButtonAsUnfollow() {
        followButton.backgroundColor = .systemBackground
        followButton.setTitle("Unfollow", for: .normal)
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = UIColor.twitterBlueColor.cgColor
        followButton.setTitleColor(.twitterBlueColor, for: .normal)
        followButton.isHidden = false
        currentFollowState = .userIsFollowed
    }
    
    func configureButtonAsFollow() {
        followButton.setTitle("Follow", for: .normal)
        followButton.layer.borderColor = UIColor(.clear).cgColor
        followButton.backgroundColor = .twitterBlueColor
        followButton.setTitleColor(.white, for: .normal)
        followButton.isHidden = false
        currentFollowState = .userIsNotFollowed
    }
    
    func configureButtonAsPersonal() {
        followButton.isHidden = true
        currentFollowState = .personal
    }
    
    @objc private func didTapFollowButton() {
        followButtonActionPublisher.send(currentFollowState)
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else {return}
        switch label {
        case SectionTabs.tweets.rawValue:
            selectedTab = SectionTabs.tweets.index
        case SectionTabs.tweetsAndReplies.rawValue:
            selectedTab = SectionTabs.tweetsAndReplies.index
        case SectionTabs.media.rawValue:
            selectedTab = SectionTabs.media.index
        case SectionTabs.likes.rawValue:
            selectedTab = SectionTabs.likes.index
        default:
            selectedTab = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        
        for i in 0..<tabs.count {
            let leadingAncor = indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAncors.append(leadingAncor)
            let trailingAncor = indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAncors.append(trailingAncor)
            
        }
        
        let profileHeaderImageViewConstraints = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let profileAvatarImageViewConstraints = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: profileHeaderImageView.leadingAnchor, constant: 20),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10)
        ]
        
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 20)
        ]
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
        ]
        
        let userBioLabelConstraints = [
            userBioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            userBioLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ]
        
        let joinDateImageViewConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor, constant: 5)
        ]
        
        let joinDateLabelConstraints = [
            joinDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ]
        
        let followingCountLabelConstraints = [
            followingCountLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 10)
        ]
        
        let followingTextLabelConstraints = [
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 4),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let followersCountLabelConstraints = [
            followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor, constant: 8),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingTextLabel.bottomAnchor)
        ]
        
        let followersTextLabelConstraints = [
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 4),
            followersTextLabel.bottomAnchor.constraint(equalTo: followersCountLabel.bottomAnchor)
        ]
        
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorConstraints = [
            leadingAncors[0],
            trailingAncors[0],
            indicator.topAnchor.constraint(equalTo: sectionStack.bottomAnchor, constant: -4),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        
        let followButtonConstraints = [
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            followButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 90),
            followButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(userBioLabelConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(joinDateLabelConstraints)
        NSLayoutConstraint.activate(followingCountLabelConstraints)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followersCountLabelConstraints)
        NSLayoutConstraint.activate(followersTextLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
        NSLayoutConstraint.activate(indicatorConstraints)
        NSLayoutConstraint.activate(followButtonConstraints)
    }
    
    

}
