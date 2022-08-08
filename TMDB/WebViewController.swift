//
//  WebViewController.swift
//  TMDB
//
//  Created by 한상민 on 2022/08/09.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var movieID = 0
    var destinationURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TrendMediaAPIManager.shared.getVideo(id: movieID) { videoKey in
            self.destinationURL = EndPoint.youtubeURL + videoKey
            DispatchQueue.main.async {
                self.openWebPage(url: self.destinationURL)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func openWebPage(url: String) {
        print(url)
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

