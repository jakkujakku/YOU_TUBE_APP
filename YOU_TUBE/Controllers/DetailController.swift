//
//  DetailController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit
import WebKit


class DetailController: UIViewController {
    
    @IBOutlet weak var video: WKWebView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var videoTitle: UILabel!
    
    
    @IBOutlet weak var readCount: UILabel!
    
    @IBOutlet weak var publishedDate: UILabel!
    
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var popularOrder: UIButton!
    
    @IBOutlet weak var latestOrder: UIButton!
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func popularOrderTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func latestOrderTapped(_ sender: UIButton) {
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
    }
    
    
    
}



extension DetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? DetailPageTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}




extension DetailController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //페이지 로드 -> 자동 동영상 재생
        //동영상 재생 제어 버튼 추가.
    }
}
