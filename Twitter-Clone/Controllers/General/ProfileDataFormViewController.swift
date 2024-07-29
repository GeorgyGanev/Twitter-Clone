//
//  ProfileDataFormViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 24.07.24.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFormViewController: UIViewController {
    
    private let viewModel = ProfileDataFormViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()

    private let hintLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fill in your data"
        label.font = .systemFont(ofSize: 31, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let avatarPlaceholderImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        imageView.backgroundColor = .lightGray
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let displayNameTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.attributedPlaceholder = NSAttributedString(string: "Display Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let usernameTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let bioTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 18)
        textView.textColor = .gray
        textView.text = "Tell the world about yourself"
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .secondarySystemFill
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return textView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        
        isModalInPresentation = true
        
        usernameTextField.delegate = self
        displayNameTextField.delegate = self
        bioTextView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarPlaceholderImageView)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        configureConstraints()
        
        avatarPlaceholderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToSelectPhoto)))
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        bindViews()
    }
    
    private func bindViews() {
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        
        viewModel.$isFormValid.sink { [weak self] state in
            self?.submitButton.isEnabled = state
        }
        .store(in: &subscriptions)
        
        viewModel.$isOnboardingFinished.sink { [weak self] success in
            self?.dismiss(animated: true)
        }
        .store(in: &subscriptions)
    }
    
    @objc private func didTapSubmit() {
        viewModel.uploadAvatar()
    }
    
    @objc private func didUpdateUsername() {
        viewModel.username = usernameTextField.text
        viewModel.validateUserProfileForm()
    }
    
    @objc private func didUpdateDisplayName() {
        viewModel.displayName = displayNameTextField.text
        viewModel.validateUserProfileForm()
    }
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didTapToSelectPhoto() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func configureConstraints() {
        
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let hintLabelConstraints = [
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ]
        
        let avatarPlaceholderImageViewConstraints = [
            avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarPlaceholderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30)
        ]
        
        let displayNameTextFieldConstraints = [
            displayNameTextField.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor, constant: 40),
            displayNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        
        let usernameTextFieldConstraints = [
            usernameTextField.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalTo: displayNameTextField.heightAnchor)
        ]
        
        let bioTextViewConstraints = [
            bioTextView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            bioTextView.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(hintLabelConstraints)
        NSLayoutConstraint.activate(avatarPlaceholderImageViewConstraints)
        NSLayoutConstraint.activate(displayNameTextFieldConstraints)
        NSLayoutConstraint.activate(usernameTextFieldConstraints)
        NSLayoutConstraint.activate(bioTextViewConstraints)
        NSLayoutConstraint.activate(submitButtonConstraints)
    }



}

extension ProfileDataFormViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
        if textView.textColor == .gray {
            textView.text = ""
            textView.textColor = .label
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
        if textView.text == "" {
            textView.textColor = .gray
            textView.text = "Tell the world about yourself"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(.init(x: 0, y: textField.frame.origin.y - 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text
        viewModel.validateUserProfileForm()
    }
}

extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarPlaceholderImageView.contentMode = .scaleAspectFill
                        self?.avatarPlaceholderImageView.image = image
                        self?.viewModel.imageData = image
                        self?.viewModel.validateUserProfileForm()
                    }
                }
            }
        }
    }
    
    
}
