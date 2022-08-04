//
//  ViewController.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    let searchController = UISearchController()
    
    var list: [Movie] = []
    var startPage = 1
    var totalCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        
        getMediaData()
        // Do any additional setup after loading the view.
    }
    
    func setGenres() {
        let url = EndPoint.genreURL + APIKey.TMDB + Language.korean
        AF.request(url, method: .get).validate(statusCode: 200...300).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMediaData() {
        let trendUrl = EndPoint.trendURL + APIKey.TMDB + "&page=\(startPage)"
        AF.request(trendUrl, method: .get).validate(statusCode: 200...300).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let creditsUrl = EndPoint.movieURL + "movie_id" + "/credits?api_key=" + APIKey.TMDB + Language.korean
                AF.request(creditsUrl, method: .get).validate(statusCode: 200...300).responseData { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath)  as? TrendCollectionViewCell else {return UICollectionViewCell()}
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 1
            }
        }
    }
    
    
}

