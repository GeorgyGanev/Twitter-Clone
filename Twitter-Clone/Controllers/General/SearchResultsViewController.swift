//
//  SearchResultsViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 29.07.24.
//

import UIKit
import SDWebImage

class SearchResultsViewController: UIViewController {
    
    var users: [TwitterUser] = []
    
    private let searchResultsTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchResultsTableView)
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        
        configureConstraints()
    
    }
    
    private func configureConstraints() {
        let searchResultsTableViewConstraints = [
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(searchResultsTableViewConstraints)
    }
    
    func updateUsers(users: [TwitterUser]) {
        self.users = users
        DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
        }
    }
  
}

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = users[indexPath.row]
        let profileViewModel = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        present(vc, animated: true)
    }
    
}
