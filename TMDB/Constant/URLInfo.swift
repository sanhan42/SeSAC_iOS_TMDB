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

struct EndPoint { // 일단 전부 무비 기준으로 작성
    static let trendURL = "https://api.themoviedb.org/3/trending/movie/week?api_key="
    static let genreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key="
    static let movieURL = "https://api.themoviedb.org/3/movie/"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    static let youtubeURL = "https://www.youtube.com/watch?v="
}
