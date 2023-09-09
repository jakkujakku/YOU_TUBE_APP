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
    
    //싱글톤 네트워킹
    var networking = CommentNetworking.shared
    
    // 썸네일 컨트롤러에서 받은 데이터
    var videoData: Items?
    
    var commentService: CommentService2?
    
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
    
    var upCount = 0
    var downCount = 8962
    
    var contentOrderSelected = false
    var latestOrderSelected = true
    
    var sortedComments: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let videoData = videoData?.id else { return }
        view.backgroundColor = .systemBackground
        configuration()
        configUI()
        dataConfigUI()
        laodVideo(videoID: videoData)
        getCommnetData(url: "https://youtube.googleapis.com/youtube/v3/commentThreads?part=id&part=replies&part=snippet&maxResults=100&textFormat=plainText&videoId=\(videoData)&key=AIzaSyDiUN58pJ1SBYkxw3G67l250-ZEe_AfzLo")
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
        downButton.setTitle(addCommas(to: downCount), for: .normal)
        
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
            upCount -= 1
            upButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            upButton.setTitle(addCommas(to: upCount), for: .normal)
        } else {
            upCount += 1
            upButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            upButton.setTitle(addCommas(to: upCount), for: .normal)
        }
        sender.isSelected = !sender.isSelected
        tableView.reloadData()

    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            downCount -= 1
            downButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            downButton.setTitle(addCommas(to: downCount), for: .normal)
        } else {
            downCount += 1
            downButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            downButton.setTitle(addCommas(to: downCount), for: .normal)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let videoData = videoData else { return }
        guard let objectshared = videoData.snippet?.localized?.description else { return }
        let activityVC = UIActivityViewController(activityItems: [objectshared], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        present(activityVC, animated: true)
    }
    
    private func sortComments() {
        guard var commentService = commentService?.items else { return }

        if contentOrderSelected {
       
             commentService.sort { $0.snippet?.topLevelComment.snippet.textOriginal ?? "" > ($1.snippet?.topLevelComment.snippet.textOriginal ?? "")! }
            sortedComments = commentService
        } else if latestOrderSelected {
  
            commentService.sort { $0.snippet?.topLevelComment.snippet.publishedAt ?? "" > $1.snippet?.topLevelComment.snippet.publishedAt ?? "" }
            sortedComments = commentService
        }

        tableView.reloadData()
    }
    
    
    @IBAction func contentsOrderTapped(_ sender: UIButton) {
        guard let videoData = videoData?.id else { return }
        contentOrderSelected = true
        latestOrderSelected = false

        getCommnetData(url: "https://youtube.googleapis.com/youtube/v3/commentThreads?part=id&part=replies&part=snippet&maxResults=100&textFormat=plainText&videoId=\(videoData)&key=AIzaSyDiUN58pJ1SBYkxw3G67l250-ZEe_AfzLo")
        contentsOrder.backgroundColor = .systemGray2
        latestOrder.backgroundColor = .systemGray6
        contentsOrder.titleLabel?.textColor = .black
        contentsOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        latestOrder.titleLabel?.font = UIFont.systemFont(ofSize: 15)


    }
    
    @IBAction func latestOrderTapped(_ sender: UIButton) {
        guard let videoData = videoData?.id else { return }
        contentOrderSelected = false
        latestOrderSelected = true

        getCommnetData(url: "https://youtube.googleapis.com/youtube/v3/commentThreads?part=id&part=replies&part=snippet&maxResults=100&textFormat=plainText&videoId=\(videoData)&key=AIzaSyDiUN58pJ1SBYkxw3G67l250-ZEe_AfzLo")
        contentsOrder.titleLabel?.textColor = .red
        contentsOrder.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        latestOrder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        contentsOrder.backgroundColor = .systemGray6
        latestOrder.backgroundColor = .systemGray2

    }
    
    // 댓글 추가
    @IBAction func sendButtonTapped(_ sender: UIButton) {
      
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
    
    
    //숫자에 ,
    private func addCommas(to number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    //날짜 변환
    func convertDateString(_ inputDateString: String, from inputFormat: String, to outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: inputDateString) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
    
//
    
    private func getCommnetData(url: String) {
        networking.performRequest(with: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(result):
                    self.commentService = result
                    self.sortComments()
                    self.tableView.reloadData()
                case let .failure(error):
                    print(error.localizedDescription)
            }
            
            }
        }
    }
    
    private func loadImage(url: String, cell: DetailPageTableViewCell) {
            guard let url = URL(string: url)  else { return }
            
            DispatchQueue.global().async {
            
                guard let data = try? Data(contentsOf: url) else { return }

                DispatchQueue.main.async {
                    cell.commentUserImage.image = UIImage(data: data)
                    cell.commentUserImage.layer.cornerRadius = cell.commentUserImage.frame.height / 2
                    cell.commentUserImage.clipsToBounds = true
                }
            }
        }
    
    
}

// 유튜브 api를 받은 후에 변경 예정, 댓글 정보에 따라
extension DetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedComments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? DetailPageTableViewCell else { return UITableViewCell() }
        guard let commentService = sortedComments[indexPath.row].snippet?.topLevelComment else { return cell}
         let userData = commentService.snippet
        cell.commentUserName.text = userData.authorDisplayName
        loadImage(url: userData.authorProfileImageURL ?? "", cell: cell)
        cell.postedCommentDate.text = convertDateString(userData.publishedAt , from: "yyyy-MM-dd'T'HH:mm:ss'Z'", to: "yyyy년 MM월 dd일 HH:mm")
        cell.comment.text = userData.textOriginal
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
