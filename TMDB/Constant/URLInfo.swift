//
//  URLInfo.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/05.
//

import Foundation

struct Language {
    static let korean = "&language=ko-KR"
}

enum MovieList: String, CaseIterable {
    case similar = "비슷한 영화"
    case recommendation = "추천 영화"
    case popular = "현재 인기 영화"
    case topRated = "인기 순위 영화"
    
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

struct EndPoint { // 일단 전부 무비 기준으로 작성
    private init () {}
    static let trendURL = "https://api.themoviedb.org/3/trending/movie/week?api_key="
    static let genreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key="
    static let movieURL = "https://api.themoviedb.org/3/movie/"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    static let youtubeURL = "https://www.youtube.com/watch?v="
}
