//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/07.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieInfoTableView: UITableView!
    @IBOutlet weak var bgImageview: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie = Movie(id: 0, title: "", release: "", genreIds: [], posterPath: "", backdropPath: "", Overview: "", vote_average: 0, casts: [], crews: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieInfoTableView.delegate = self
        movieInfoTableView.dataSource = self
        
        title = "출연/제작"
        
        if #available(iOS 15, *) {
            movieInfoTableView.sectionHeaderTopPadding = 16
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1 : return movie.casts.count
        case 2 : return movie.crews.count
        default : return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "OverView"
        case 1: return "Cast"
        case 2: return "Crew"
        default : return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier) as! OverviewTableViewCell
        let castCell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as! CastTableViewCell
        let crewCell = tableView.dequeueReusableCell(withIdentifier: CrewTableViewCell.identifier) as! CrewTableViewCell
        
        switch indexPath.section {
        case  0 :
            overviewCell.overviewLabel.text = movie.Overview
            return overviewCell
        case 1 :
            castCell.nameLabel.text = movie.casts[indexPath.item].name
            castCell.characterLabel.text = movie.casts[indexPath.item].character
            if movie.casts[indexPath.item].profilePath == "" {
                castCell.profileImageView.image = UIImage(named: "noimg")
                return castCell
            }
            guard let url = URL(string: EndPoint.imageURL+movie.casts[indexPath.item].profilePath) else { return castCell }
            castCell.profileImageView.load(url: url)
            return castCell
        case 2 :
            crewCell.nameLabel.text = movie.crews[indexPath.item].name
            crewCell.departmentLabel.text = "[ \(movie.crews[indexPath.item].department) ]"
            crewCell.jobLabel.text = " \(movie.crews[indexPath.item].job)"
            if movie.crews[indexPath.item].profilePath == "" {
                crewCell.profileImageView.image = UIImage(named: "noimg")
                return crewCell
            }
            guard let url = URL(string: EndPoint.imageURL+movie.crews[indexPath.item].profilePath) else { return crewCell }
            crewCell.profileImageView.load(url: url)
            return crewCell
        default : return UITableViewCell()
        }
    }
}
