//
//  RegisterViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 21.07.24.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    private var viewModel = AuthenticationViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    

    private let registerTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "Create your account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
       let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textField
    }()
    
    private let passwordTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(registerTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        configureConstraints()
        
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        
        bindViews()
    }
    
    private func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthenticationFormValid.sink { [weak self] validationState in
            self?.registerButton.isEnabled = validationState
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else {return}
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else { return }
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else {return}
            self?.presentAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    
    
    @objc private func registerButtonClicked() {
        print("create user")
        viewModel.createUser()
    }
    
    @objc private func didChangeEmailField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    @objc private func didChangePasswordField() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Error", message: error , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func configureConstraints() {
        
        let registerTitleLabelConstraints = [
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 20)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor)
        ]
        
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 180)
        ]
        
        NSLayoutConstraint.activate(registerTitleLabelConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }

}
