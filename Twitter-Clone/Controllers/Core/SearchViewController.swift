//
//  SearchViewController.swift
//  Twitter-Clone
//
//  Created by Georgy Ganev on 7.07.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search for users and get connected"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .placeholderText
        return label
    }()
    
    let searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search users with @username"
        return searchController
    }()
    
    let viewModel: SearchViewViewModel
    
    init(viewModel: SearchViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textLabel)
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        
        let textLabelConstraints = [
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(textLabelConstraints)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text
        else { return }
        viewModel.search(with: query) { users in
            resultsController.updateUsers(users: users)
        }
    }
    
    
}
