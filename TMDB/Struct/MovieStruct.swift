//
//  MovieStruct.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/05.
//

import Foundation

struct Movie {
    var id: Int
    var title: String
    var release: String
    var genreIds: [Int]
    var posterPath: String
    var backdropPath: String
    var Overview: String
    var vote_average: Double
    var casts: [Cast]
    var crews: [Crew]
}
