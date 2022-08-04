//
//  MovieStruct.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/05.
//

import Foundation

struct Movie {
    var title: String
    var release: String
    var genreIds: [Int]
    var posterPath: String
    var Overview: String
    var casts: [Cast]
}
