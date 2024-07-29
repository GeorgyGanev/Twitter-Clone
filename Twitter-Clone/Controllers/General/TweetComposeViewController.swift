//
//  TweetComposeViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 28.07.24.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    
    private let viewModel = TweetComposeViewViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlueColor
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private let tweetContentTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 18)
        textView.textColor = .gray
        textView.text = "What's happening"
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Tweet"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        
        tweetContentTextView.delegate = self
        
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        
        configureConstraints()
        
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getUser()
    }
    
    private func bindViews() {
        viewModel.$isValidToTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = state
        }
        .store(in: &subscriptions)
        
        viewModel.$shouldDismissComposer.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        
        let tweetButtonConstraints = [
            tweetButton.heightAnchor.constraint(equalToConstant: 40),
            tweetButton.widthAnchor.constraint(equalToConstant: 120),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ]
        
        let tweetContentTextViewConstraints = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetContentTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(tweetButtonConstraints)
        NSLayoutConstraint.activate(tweetContentTextViewConstraints)
        
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapToTweet() {
        viewModel.dispatchTweet()
    }

}

extension TweetComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "What's happening"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}
