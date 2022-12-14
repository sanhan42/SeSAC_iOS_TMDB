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
    @IBOutlet weak var recommendButton: UIButton!
    
    var movie = Movie(id: 0, title: "", release: "", genreIds: [], posterPath: "", backdropPath: "", Overview: "", vote_average: 0, casts: [], crews: [])
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieInfoTableView.delegate = self
        movieInfoTableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.topItem?.title = ""
        
                
        if #available(iOS 15, *) {
            movieInfoTableView.sectionHeaderTopPadding = 16
        }
        movieInfoTableView.rowHeight = UITableView.automaticDimension
        
        recommendButton.layer.cornerRadius = 8
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        titleLabel.textColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        movieInfoTableView.reloadData()
        title = "영화 상세 정보"
        titleLabel.text = movie.title
        guard let url = URL(string: EndPoint.imageURL+movie.backdropPath) else { return }
        bgImageview.load(url: url)
        guard let url = URL(string: EndPoint.imageURL+movie.posterPath) else { return }
        posterImageView.load(url: url)
    }
    
    @IBAction func recommendButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "MovieList", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: MovieListViewController.identifier) as? MovieListViewController else { return }
        vc.movieID = movie.id
        vc.movieTitle = movie.title
        vc.beforeVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    @IBAction func chevronButtonClicked(_ sender: UIButton) {
//        isExpanded = !isExpanded
//        movieInfoTableView.reloadData()
////       왜 셀 선택이 아닌 버튼 클릭으로는 버튼의 이미지가 안바뀌지?
//    }
}


extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            isExpanded = !isExpanded
            movieInfoTableView.reloadData()
        }
    }
    
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
            overviewCell.overviewLabel.numberOfLines = isExpanded ? 0 : 2
            overviewCell.chevronButton.tintColor = .black
            overviewCell.chevronButton.isEnabled = false
            overviewCell.chevronButton.imageView?.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
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
