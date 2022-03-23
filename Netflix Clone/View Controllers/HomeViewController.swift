//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Manu on 11/03/2022.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Popular", "Trending movies", "Trending tv", "Upcoming movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 225))
        homeFeedTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func getTrendingMovies() async -> TrendingMoviesResponse? {
        do {
            return try await APICaller.shared.getTrendingMovies()
        } catch APIError.failedToGetData {
            // Show an alert or something
        } catch(let error) {
            print(error)
        }
        return nil
    }
    
    private func getTrendingShows() async -> TrendingShowsResponse? {
        do {
            return try await APICaller.shared.getTrendingShows()
        } catch APIError.failedToGetData {
            // Show an alert or something
        } catch(let error) {
            print(error)
        }
        return nil
    }
    
    private func getUpcomingMovies() async -> TrendingMoviesResponse? {
        do {
            return try await APICaller.shared.getUpcomingMovies()
        } catch APIError.failedToGetData {
            // Show an alert or something
        } catch(let error) {
            print(error)
        }
        return nil
    }
    
    private func getPopularMovies() async -> TrendingMoviesResponse? {
        do {
            return try await APICaller.shared.getPopularMovies()
        } catch APIError.failedToGetData {
            // Show an alert or something
        } catch(let error) {
            print(error)
        }
        return nil
    }
    
    private func getTopRatedMovies() async -> TrendingMoviesResponse? {
        do {
            return try await APICaller.shared.getTopRatedMovies()
        } catch APIError.failedToGetData {
            // Show an alert or something
        } catch(let error) {
            print(error)
        }
        return nil
    }
    
    private func configureNavBar() {
        var netflixLogoImage = UIImage(named: "netflixLogo")
        netflixLogoImage = netflixLogoImage?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogoImage, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self
        
        switch indexPath.section {
        case Sections.Popular.rawValue:
            Task {
                let movies: TrendingMoviesResponse? = await getPopularMovies()
                if let results = movies?.results {
                    cell.configure(with: results)
                }
            }
        case Sections.TopRated.rawValue:
            Task {
                let movies: TrendingMoviesResponse? = await getTopRatedMovies()
                if let results = movies?.results {
                    cell.configure(with: results)
                }
            }
        case Sections.Upcoming.rawValue:
            Task {
                let movies: TrendingMoviesResponse? = await getUpcomingMovies()
                if let results = movies?.results {
                    cell.configure(with: results)
                }
            }
        case Sections.TrendingMovies.rawValue:
            Task {
                let movies: TrendingMoviesResponse? = await getTrendingMovies()
                if let results = movies?.results {
                    cell.configure(with: results)
                }
            }
        case Sections.TrendingTv.rawValue:
            Task {
                let shows: TrendingShowsResponse? = await getTrendingShows()
                if let results = shows?.results {
                    cell.configure(with: results)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.width, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .secondarySystemFill
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, _ trailerModel: YoutubeTrailerModel) {
        let vc = YoutubePlayerViewController()
        vc.configure(with: trailerModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
