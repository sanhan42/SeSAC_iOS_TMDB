//
//  MovieListViewController.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/10.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var movieID = 0
//    var sectionList = ["비슷한 영화", "추천 영화", "최신 영화", "인기 영화"]
    var sectionList = MovieList.allCases.map {$0.rawValue}
    var movieLists: [[MovieListItem]] = [[], [], [], []]
    var startPage = [1, 1, 1, 1]
    var totalPages = [0, 0, 0, 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "다양한 영화"
        
        setMovieLists()
        // Do any additional setup after loading the view.
    }
    
    func setMovieLists () {
        for (i, listCase) in MovieList.allCases.enumerated() {
            TrendMediaAPIManager.shared.getMovieList(url: listCase.requestURL(id: movieID), startPage: startPage[i]) { totalPages, movieList in
                self.totalPages[i] = totalPages
                self.movieLists[i].append(contentsOf: movieList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
}



extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else { return UITableViewCell() }
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section
        cell.contentLabel.text = sectionList[indexPath.section]
        cell.contentCollectionView.register(UINib(nibName: "PosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PosterCollectionViewCell")
        cell.contentCollectionView.reloadData()
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieLists[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCollectionViewCell", for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell () }
        guard let url = URL(string: EndPoint.imageURL + movieLists[collectionView.tag][indexPath.item].posterPath) else {
            cell.posterView.posterImageView.image = UIImage(named: "posterNoImage")
            return cell
        }
        cell.posterView.posterImageView.load(url: url)
        return cell
    }
}
