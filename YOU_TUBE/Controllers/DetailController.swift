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
    
    //Networking Data
    //var videoData: ?
    
    
    //유저디폴트
    
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
    
    
    var upCount = 0
    var downCount = 0
    
    //임시 데이터
    var commentArray: [Comment] = [
        Comment(userId: "test", userImage: (UIImage(systemName: "person") ?? UIImage(systemName: "heart"))!, comment: "테스트용 - 0"),
        Comment(userId: "test", userImage: (UIImage(systemName: "pencil") ?? UIImage(systemName: "heart"))!, comment: "테스트용 - 1")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        laodVideo()
    }
    
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        if upButton.imageView?.image == UIImage(systemName: "hand.thumbsup") {
            upCount += 1
            //영상 데이터에 upcount 넣어주기
            
            self.upButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        } else {
            upCount -= 1
            
            //영상 데이터에 upcount 넣어주기
            self.upButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }
        //데이터 변화 - 유저디폴트 저장
        
    }
    
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        if upButton.imageView?.image == UIImage(systemName: "hand.thumbsdown") {
            upCount -= 1
            //영상 데이터에 upcount 넣어주기
            
            self.upButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        } else {
            upCount += 1
            
            //영상 데이터에 upcount 넣어주기
            self.upButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
        }
        //데이터 변화 - 유저디폴트 저장
        
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        //변경예정
        //share()
    }
    
    @IBAction func popularOrderTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func latestOrderTapped(_ sender: UIButton) {
        
    }
    
    //댓글 추가
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        let newData = Comment(userId: "test - \(Comment.postNumber)", userImage: (UIImage(systemName: "person") ?? UIImage(systemName: "heart"))!, comment: commentTextField.text ?? "")
        commentArray.append(newData)
        
    }
    
    //date format 함수
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)일 전"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        }
        if let second = components.second, second >= 0 {
            return "지금"
        }
        
        return ""
    }
    
    //동영상 재생 요청
    private func laodVideo() {
        video.navigationDelegate = self
        if let videoURL = URL(string: "") {
            let request = URLRequest(url: videoURL)
            video.load(request)
        }
    }
    
    // 게시물 공유 함수 (index 변경 예정)
    private func share(index: IndexPath) {
        //영상 url로 변경하기 추후에 네트워킹 데이터 받은 다음
        let objectsToShare = commentArray[index.row]
        let activityVC = UIActivityViewController(activityItems: [objectsToShare.comment], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        present(activityVC, animated: true)
    }
    
    
    
}



extension DetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? DetailPageTableViewCell else { return UITableViewCell() }
        let data = commentArray[indexPath.row]
        cell.commentUserName.text = data.userId
        cell.commentUserImage.image = data.userImage
        cell.postedCommentDate.text = timeAgoString(from: data.date)
        cell.comment.text = data.comment
        
        return cell
    }
    
    
}




extension DetailController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //페이지 로드 -> 자동 동영상 재생
        //동영상 재생 제어 버튼 추가.
    }
}
