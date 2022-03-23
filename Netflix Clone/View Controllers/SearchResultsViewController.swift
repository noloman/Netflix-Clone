//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Manu on 13/03/2022.
//

import Foundation
import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ model: YoutubeTrailerModel)
}

class SearchResultsViewController: UIViewController {
    
    var movies = [Result]()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view?.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: movie.posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let movieTitle = movie.title ?? movie.name else { return }
        Task {
            do {
                let results = try await APICaller.shared.getMovie(with: movieTitle)
                guard let youtubeMovieId = results?.items.first?.id else { return }
                let model = YoutubeTrailerModel(title: movieTitle, overview: movie.overview, videoElementId: youtubeMovieId)
                delegate?.searchResultsViewControllerDidTapItem(model)
            } catch {
                print("\(#file), \(#function): \(error)")
            }
        }
    }
}
