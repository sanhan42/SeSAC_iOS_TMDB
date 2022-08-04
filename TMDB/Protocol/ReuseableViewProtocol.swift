//
//  ReuseableViewProtocol.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/05.
//

import UIKit

protocol ReuseableViewProtocol {
    static var identifier: String { get }
}

extension TrendCollectionViewCell: ReuseableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
