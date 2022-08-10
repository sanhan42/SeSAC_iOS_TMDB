//
//  PosterCollectionViewCell.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/10.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterView: PosterView!
    // 변경되지 않는 UI 설정해줄 떄, 많이 사용
    override func awakeFromNib() {
        super.awakeFromNib()
        print("CardCollectionViewCell", #function)
        setupUI() // 컬렉션뷰에서 셀로 사용한다면, 처음 만들어질 때만, 실행되고, 셀이 재사용될 때는 호출되지 않음.
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupUI()
    }
    
    func setupUI() {
        posterView.backgroundColor = .clear
        posterView.posterImageView.backgroundColor = .lightGray
        posterView.posterImageView.layer.cornerRadius = 10
    }
}
