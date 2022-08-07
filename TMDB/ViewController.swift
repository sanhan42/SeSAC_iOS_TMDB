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
        trendCollectionView.delegate = self
        trendCollectionView.dataSource = self
        trendCollectionView.prefetchDataSource = self
        navigationItem.searchController = searchController
        setCollectionViewLayout()
        setList()
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
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing:CGFloat = 16
        let width = (UIScreen.main.bounds.width - spacing*2)
        layout.itemSize = CGSize(width: width, height: view.frame.height * 0.5)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        trendCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "MovieDetail", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {return}
        vc.movie = list[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath)  as? TrendCollectionViewCell else {return UICollectionViewCell()}
        cell.setDesign()
        let item = list[indexPath.item]
        cell.releaseLabel.text = item.release
        cell.genreLabel.text = "#" + (genres[item.genreIds[0]] ?? "영화")
        cell.voteAverageLabel.text = String(format: "%.2f", item.vote_average)
        cell.titleLabel.text = item.title
        cell.castLabel.text = item.casts.map { $0.name }.joined(separator: ", ")
        guard let url = URL(string: EndPoint.imageURL+item.posterPath) else {return cell}
        cell.posterImage.load(url: url)
        
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalPages {
                startPage += 1
                self.setList()
            }
        }
    }
    
    
}

