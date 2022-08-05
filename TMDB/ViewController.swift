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
    @IBOutlet weak var trendCollectionView: UICollectionView!
    
    var list: [Movie] = []
    var startPage = 1
    var totalCount = 0

    let semaphore = DispatchSemaphore(value: 1)
    
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
    
    func getCast(id: Int) -> [Cast] {
        let creditsUrl = EndPoint.movieURL + "\(id)" + "/credits?api_key=" + APIKey.TMDB + Language.korean
        var rtn: [Cast] = []
        AF.request(creditsUrl, method: .get).validate(statusCode: 200...300).responseData(queue:.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print(json)
                for person in json["cast"].arrayValue {
                    if person["known_for_department"].stringValue == "Acting" {
                        rtn.append(Cast(name: person["name"].stringValue, profilePath: person["profile_path"].stringValue, character: person["character"].stringValue, id: person["id"].intValue))
                    }
                }
            case .failure(let error):
                print(error)
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
//        print("@@@@@@@@@@", rtn)
        return rtn
    }
    
    func getMediaData() {
        let trendUrl = EndPoint.trendURL + APIKey.TMDB + "&page=\(startPage)"
        AF.request(trendUrl, method: .get).validate(statusCode: 200...300).responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for movie in json["results"].arrayValue {
                    semaphore.wait()
                    let castList: [Cast] = getCast(id: movie["id"].intValue) // 이 함수 호출이 완료되길 기다려주고 싶은데 방법을 모르겠다 => semaphore로 해결!
                    semaphore.signal()
                    list.append(Movie(id: movie["id"].intValue, title: movie["title"].stringValue, release: movie["release_date"].stringValue, genreIds: movie["genre_ids"].arrayObject as? [Int] ?? [0], posterPath: movie["poster_path"].stringValue, Overview: movie["overview"].stringValue, casts: castList))
                }
            case .failure(let error):
                print(error)
            }
            trendCollectionView.reloadData()
            print(list)
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

