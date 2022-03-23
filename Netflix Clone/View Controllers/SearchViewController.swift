//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Manu on 11/03/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies = [Result]()
    
    private let searchViewController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        searchViewController.searchResultsUpdater = self
        
        navigationItem.searchController = searchViewController
        
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        Task {
            let movies = try? await APICaller.shared.getDiscoverMovies()
            if let movies = movies {
                self.movies = movies.results
                discoverTable.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let movie = TitleViewModel(titleName: movies[indexPath.row].originalTitle ?? movies[indexPath.row].originalName ?? "Unknown name", posterURL: movies[indexPath.row].posterPath ?? "")
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let titleName = movie.originalTitle ?? movie.originalName else {
            return
        }
        
        Task {
            let results = try await APICaller.shared.getMovie(with: titleName)
            let vc = YoutubePlayerViewController()
            guard let videoId = results?.items.first?.id else { return }
            vc.configure(with: YoutubeTrailerModel(title: titleName, overview: movie.overview, videoElementId: videoId))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ model: YoutubeTrailerModel) {
        let vc = YoutubePlayerViewController()
        vc.configure(with: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegate = self
        
        Task {
            let searchResults = try? await APICaller.shared.search(query)
            if let searchResults = searchResults {
                resultsController.movies = searchResults.results
                resultsController.searchResultsCollectionView.reloadData()
            }
        }
    }
}
