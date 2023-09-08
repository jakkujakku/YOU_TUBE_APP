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
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Networking Data
    var videoData: Items?
    
    // 유저디폴트
    
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBOutlet weak var readCount: UILabel!
    
    @IBOutlet weak var publishedDate: UILabel!
    
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var contentsOrder: UIButton!
    
    @IBOutlet weak var latestOrder: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    // 나중에 유튜브 좋아요 수로 변경
    var upCount = 0
    var downCount = 0
    
    // 임시 데이터
    var commentArray: [Comment] = [
        Comment(userId: "test", userImage: (UIImage(systemName: "person") ?? UIImage(systemName: "heart"))!, comment: "테스트용 - 0"),
        Comment(userId: "test", userImage: (UIImage(systemName: "pencil") ?? UIImage(systemName: "heart"))!, comment: "테스트용 - 1")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let videoData = videoData else { return }
        view.backgroundColor = .systemBackground
        configuration()
        configUI()
        dataConfigUI()
        laodVideo(videoID: videoData.id ?? "")
    }
    
    private func configuration() {
        tableView.dataSource = self
        tableView.delegate = self
        contentsOrder.isSelected = true
        latestOrder.isSelected = false
        indicator.isHidden = false
        video.isHidden = true
    }
    
    private func configUI() {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        upButton.layer.cornerRadius = 10
        downButton.layer.cornerRadius = 10
        latestOrder.layer.cornerRadius = 10
        contentsOrder.layer.cornerRadius = 10
        shareButton.layer.cornerRadius = 10
        
        userImage.clipsToBounds = true
        upButton.clipsToBounds = true
        downButton.clipsToBounds = true
        latestOrder.clipsToBounds = true
        contentsOrder.clipsToBounds = true
        shareButton.clipsToBounds = true
//        tableView.rowHeight = 120
        commentTextField.placeholder = "댓글을 입력해 주세요."
        videoTitle.numberOfLines = 0
        videoTitle.lineBreakMode = .byWordWrapping
    }
    
    private func dataConfigUI() {
        guard let snippet = videoData?.snippet else { return }
        guard let statistics = videoData?.statistics else { return }
        videoTitle.text = snippet.title
        readCount.text = addCommas(to: Int(statistics.viewCount!)!)
        publishedDate.text = convertDateString(snippet.publishedAt ?? "", from: "yyyy-MM-dd'T'HH:mm:ss'Z'", to: "yyyy년 MM월 dd일 HH:mm")

        upButton.setTitle(addCommas(to: Int(statistics.likeCount!)!), for: .normal)
//        downButton.setTitle(addCommas(to: Int(statistics.dislikeCount!)!), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // API JSON 파일의 구조체 프로퍼티에 영향을 받아 값을 변경 저장, 값 불러오기
    @IBAction func upButtonTapped(_ sender: UIButton) {
        guard let statistics = videoData?.statistics else { return }
        upCount = Int(statistics.likeCount!)!
        
        if sender.isSelected {
            upCount += 1
            upButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            upButton.setTitle(addCommas(to: upCount), for: .normal)
        } else {
            upCount -= 0
            upButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            upButton.setTitle(addCommas(to: upCount), for: .normal)
        }
        sender.isSelected = !sender.isSelected
//         데이터 변화 - 유저디폴트 저장
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        guard let statistics = videoData?.statistics else { return }
        downCount = Int(statistics.dislikeCount!)!
        
        if sender.isSelected {
            downCount += 1
            downButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            downButton.setTitle(addCommas(to: downCount), for: .normal)
        } else {
            downCount -= 0
            upButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            downButton.setTitle(addCommas(to: downCount), for: .normal)
        }
        sender.isSelected = !sender.isSelected
//         데이터 변화 - 유저디폴트 저장
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
         share()
    }
    
    @IBAction func contentsOrderTapped(_ sender: UIButton) {
        if contentsOrder.isSelected {
            // 내용으로 순서 변경
            commentArray.sort { $0.comment.count > $1.comment.count }
            
            contentsOrder.backgroundColor = .systemGray2
            latestOrder.backgroundColor = .systemGray6
            contentsOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            latestOrder.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            contentsOrder.isSelected = false
            latestOrder.isSelected = true
            tableView.reloadData()
        }
    }
    
    @IBAction func latestOrderTapped(_ sender: UIButton) {
        if latestOrder.isSelected {
            // 최신순으로 순서 변경
            commentArray.sort { $0.date > $1.date }
            
            contentsOrder.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            latestOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            contentsOrder.backgroundColor = .systemGray6
            latestOrder.backgroundColor = .systemGray2
            contentsOrder.isSelected = true
            latestOrder.isSelected = false
            tableView.reloadData()
        }
    }
    
    // 댓글 추가
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        let newData = Comment(userId: "test - \(Comment.postNumber)", userImage: (UIImage(systemName: "person") ?? UIImage(systemName: "heart"))!, comment: commentTextField.text ?? "")
        commentArray.append(newData)
        
        // 값 저장유저디폴트
    
        tableView.reloadData()
    }
    
    // date format 함수
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
    
    // 동영상 재생 요청
    private func laodVideo(videoID: String) {
        video.navigationDelegate = self
        if let videoURL = URL(string: "https://www.youtube.com/embed/\(videoID)") {
            let request = URLRequest(url: videoURL)
            video.load(request)
        }
    }
    
    // 게시물 공유 함수
    private func share() {
        guard let videoData = videoData else { return }
        let objectsToShare = videoData.snippet?.descriptions
        let activityVC = UIActivityViewController(activityItems: [objectsToShare as Any], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        present(activityVC, animated: true)
    }
    
    private func addCommas(to number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    func convertDateString(_ inputDateString: String, from inputFormat: String, to outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: inputDateString) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
}

// 유튜브 api를 받은 후에 변경 예정, 댓글 정보에 따라
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("로딩 시작")
        indicator.startAnimating()
        indicator.isHidden = false
        video.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("로드완료")
        indicator.stopAnimating()
        indicator.isHidden = true
        video.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let errorMessage = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okay)
        present(alert, animated: true)
    }
}
