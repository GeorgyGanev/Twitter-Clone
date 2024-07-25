//
//  OnboardingViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 21.07.24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "See what's happening in the world right now"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return button
    }()
    
    private let promptLabel: UILabel = {
       let label = UILabel()
        label.text = "Have an account already?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
        
        configureConstraints()
        
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

    }
    
    @objc private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCreateAccount() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    private func configureConstraints() {
        
        let welcomeLableConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let createAccountButtonConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        
        let loginButtonConstraints = [
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10),
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(welcomeLableConstraints)
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }

}
