//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Manu on 11/03/2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    private var movies = [Result]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        Task {
            let movies = try? await APICaller.shared.getUpcomingMovies()
            configure(with: movies?.results ?? [Result]())
        }
    }
    
    private func configure(with model: [Result]) {
        self.movies = model
        self.upcomingTable.reloadData()
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = movies[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.originalTitle ?? title.originalName) ?? "Unknown name", posterURL: title.posterPath ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
