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
    let genres: [Int:String] = TrendMediaAPIManager.shared.getGenresData()
    var startPage = 1
    var totalPages = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        setList()
        print(genres)
        // Do any additional setup after loading the view.
    }
    
    func setList () {
        TrendMediaAPIManager.shared.getMediaData(startPage: startPage) { totalPages, list in
            self.totalPages = totalPages
            self.list.append(contentsOf: list)
//            print(self.list)
//            print("Total  : ", self.totalPages)
            DispatchQueue.main.async {
                self.trendCollectionView.reloadData()
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
            if list.count - 1 == indexPath.item && list.count < totalPages {
                startPage += 1
            }
        }
    }
    
    
}

