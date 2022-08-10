//
//  PosterView.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/10.
//

import UIKit

class PosterView: UIView {
    @IBOutlet weak var posterImageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        self.addSubview(view)
    }
}
