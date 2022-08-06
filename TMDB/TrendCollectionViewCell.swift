//
//  TrendCollectionViewCell.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/05.
//

import UIKit

class TrendCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var linkButton: UIButton!
    
    func setDesign() {
        releaseLabel.textColor = .darkGray
        releaseLabel.font = .systemFont(ofSize: 14)
        posterImage.contentMode = .scaleAspectFill
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.clear.cgColor
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowOffset = CGSize(width:0, height: 0)
        shadowView.layer.shadowRadius = 20
        lineView.layer.borderColor = UIColor.label.cgColor
        lineView.layer.borderWidth = 2
        genreLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        castLabel.font = .systemFont(ofSize: 17)
        castLabel.textColor = .darkGray
        linkButton.layer.cornerRadius = linkButton.frame.width/2
    }
}
