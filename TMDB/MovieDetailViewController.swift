//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/07.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var bgImageview: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie = Movie(id: 0, title: "", release: "", genreIds: [], posterPath: "", backdropPath: "", Overview: "", vote_average: 0, casts: [], crews: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "출연/제작"
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.text = movie.title
        guard let url = URL(string: EndPoint.imageURL+movie.backdropPath) else { return }
        bgImageview.load(url: url)
        guard let url = URL(string: EndPoint.imageURL+movie.posterPath) else { return }
        posterImageView.load(url: url)
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2 : return movie.casts.count
        case 3 : return movie.crews.count
        default : return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier) as! OverviewTableViewCell
        let castCell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as! CastTableViewCell
        let crewCell = tableView.dequeueReusableCell(withIdentifier: CrewTableViewCell.identifier) as! CrewTableViewCell
        
        switch indexPath.section {
        case 1 : return overviewCell
        case 2 : return castCell
        case 3 : return crewCell
        default : return UITableViewCell()
        }
    }
}
