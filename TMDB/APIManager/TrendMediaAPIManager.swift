//
//  TrendMediaAPIManager.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/06.
//

import Foundation
import Alamofire
import SwiftyJSON

class TrendMediaAPIManager {
    let semaphore = DispatchSemaphore(value: 1)
    
    static let shared = TrendMediaAPIManager()
    private init () {}
    
    typealias CompletionHandler = (Int, [Movie]) -> ()
    
    func getMovieList(url:String, startPage:Int, completionHandler: @escaping (Int, [MovieListItem]) -> ()) {
        var list: [MovieListItem] = []
        var totalPages: Int = 0
        let requestUrl = url + "&page=\(startPage)"
        semaphore.wait()
        AF.request(requestUrl, method: .get).validate(statusCode: 200...300).responseData(queue: .global()) { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                totalPages = json["total_pages"].intValue
                for movie in json["results"].arrayValue {
                    list.append(MovieListItem(id: movie["id"].intValue, title: movie["title"].stringValue, posterPath: movie["poster_path"].stringValue))
                }
            case .failure(let error):
                print(error)
            }
            completionHandler(totalPages,list)
            semaphore.signal()
        }
    }
    
    func getGenresData() -> [Int:String] {
        var genres: [Int:String] = [:]
        let url = EndPoint.genreURL + APIKey.TMDB + Language.korean
        semaphore.wait()
        AF.request(url, method: .get).validate(statusCode: 200...300).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let dicValue = json["genres"].arrayValue.map {($0["id"].intValue, $0["name"].stringValue)}
                genres = Dictionary(uniqueKeysWithValues: dicValue)
//                print(genres)
            case .failure(let error):
                print(error)
            }
            self.semaphore.signal()
        }
        semaphore.wait()
        semaphore.signal()
        return genres
    }

    func getVideo(id: Int, completionHandler: @escaping (String) -> ()) {
        var videoUrl = EndPoint.movieURL + "\(id)" + "/videos?api_key=" + APIKey.TMDB + Language.korean
        var videoKey = ""
        semaphore.wait()
        AF.request(videoUrl, method: .get).validate(statusCode: 200...300).responseData(queue:.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)["results"].arrayValue
                if json.isEmpty {
                    videoUrl = EndPoint.movieURL + "\(id)" + "/videos?api_key=" + APIKey.TMDB
                }
            case .failure(let error):
                print(error)
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
        AF.request(videoUrl, method: .get).validate(statusCode: 200...300).responseData(queue:.global()) { response in
            switch response.result {
            case .success(let value):
                videoKey = JSON(value)["results"].arrayValue[0]["key"].stringValue
            case .failure(let error):
                print(error)
            }
            self.semaphore.signal()
            completionHandler(videoKey)
        }
    }
    
    func getCrew(id: Int) -> [Crew] {
        let creditsUrl = EndPoint.movieURL + "\(id)" + "/credits?api_key=" + APIKey.TMDB + Language.korean
        var rtn: [Crew] = []
        AF.request(creditsUrl, method: .get).validate(statusCode: 200...300).responseData(queue:.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for person in json["crew"].arrayValue {
                    if person["known_for_department"].stringValue == "Acting" {
                        rtn.append(Crew(name: person["name"].stringValue, profilePath: person["profile_path"].stringValue, department: person["department"].stringValue, job: person["job"].stringValue))
                    }
                }
            case .failure(let error):
                print(error)
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
        return rtn
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
    
    func getMediaData(startPage:Int, completionHandler: @escaping CompletionHandler) {
        var list: [Movie] = []
        var totalPages: Int = 0
        let trendUrl = EndPoint.trendURL + APIKey.TMDB + "&page=\(startPage)" + Language.korean
        AF.request(trendUrl, method: .get).validate(statusCode: 200...300).responseData(queue: .global()) { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                totalPages = json["total_pages"].intValue
                for movie in json["results"].arrayValue {
                    semaphore.wait()
                    let castList: [Cast] = getCast(id: movie["id"].intValue) // 이 함수 호출이 완료되길 기다려주고 싶은데 방법을 모르겠다 => semaphore로 해결!
                    let crewList: [Crew] = getCrew(id: movie["id"].intValue)
                    semaphore.signal()
                    list.append(Movie(id: movie["id"].intValue, title: movie["title"].stringValue, release: movie["release_date"].stringValue, genreIds: movie["genre_ids"].arrayObject as? [Int] ?? [0], posterPath: movie["poster_path"].stringValue, backdropPath: movie["backdrop_path"].stringValue, Overview: movie["overview"].stringValue,vote_average: movie["vote_average"].doubleValue ,casts: castList, crews: crewList))
                }
            case .failure(let error):
                print(error)
            }
            completionHandler(totalPages,list)
        }
    }
}
