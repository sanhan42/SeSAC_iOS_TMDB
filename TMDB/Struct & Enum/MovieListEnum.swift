//
//  MovieListEnum.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/11.
//

import Foundation

enum MovieList: String, CaseIterable {
    case similar = "비슷한 영화"
    case recommendation = "추천 영화"
    case popular = "현재 인기 영화"
    case topRated = "최고 평점 영화"
    
    func requestURL(id: Int) -> String {
        switch self {
        case .similar:
            return "\(EndPoint.movieURL)\(id)/similar?api_key=\(APIKey.TMDB)\(Language.korean)"
        case .recommendation:
            return "\(EndPoint.movieURL)\(id)/recommendations?api_key=\(APIKey.TMDB)\(Language.korean)"
        case .popular:
            return "\(EndPoint.movieURL)popular?api_key=\(APIKey.TMDB)\(Language.korean)"
        case .topRated:
            return "\(EndPoint.movieURL)top_rated?api_key=\(APIKey.TMDB)\(Language.korean)"
        }
    }
}
