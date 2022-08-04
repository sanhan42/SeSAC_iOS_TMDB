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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        // Do any additional setup after loading the view.
    }
    
    func getMovieData() {
        
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...300).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.totalCount = json["total"].intValue
                for item in json["items"].arrayValue {
                    guard let url = URL(string: item["link"].stringValue) else { return }
                    self.list.append(url)
                }
                // 서버통신 받는 시점에서 URL, UIImage 변환을 할 건지 => 서버 통신 시간 오래 걸림.
                // 셀에서 URL, UIImage 변환을 할 건지 => 이 방식이 일반적이다. 서버 통신을 최대한 빠르게 마무리하고, 데이터 변환 작업은 다른 곳에서 처리.
            case .failure(let error):
                print(error)
            }
            self.imageCollectionView.reloadData() // 까먹지 말자!!
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

