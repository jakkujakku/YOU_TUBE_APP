//
//  ThumbnailController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import Kingfisher
import UIKit

// 검색 기능
// 위로 스와이프 시, 셀 리로드 --> 스와이프 할 때, 삭제하고 데이터 불러오기 구현해야함.
// 숫자 100000만 초과시 -> . 찍기 --> 31만 --> 3.1만 ✅
// let regionCode = [us, kr, jr, en, fr] ✅
// var randomValue = Int.random(0...regionCode.cout) ✅

enum RegionCode: String, CaseIterable {
    case kr
    case us
    case fr
    case jp
    case br
    case hk
}

class ThumbnailController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshControll: UIRefreshControl = .init()

    var thumbnailInfoList = DataManager.shared
    let regionCode: [RegionCode] = [.kr, .us, .fr, .jp, .br, .hk]
    let regionCodeCount = RegionCode(rawValue: RegionCode.kr.rawValue)
    static var random = Int.random(in: 0 ..< RegionCode.allCases.count)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Video List"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupUI()
        addSearchBar()
        topViewUp()
        getYoutubeData(regionCode: regionCode[ThumbnailController.random].rawValue, apiKey: MediaServiceManager.apiKey)

        initRefreshControll()
    }

    func getYoutubeData(regionCode: String, apiKey: String) {
//        let url = URL(string: MediaServiceManager.baseURL+regionCode+MediaServiceManager.conditionURL+regionCode+MediaServiceManager.keyURL+apiKey)!
        let jsonMockUp = Bundle.main.url(forResource: regionCode, withExtension: "json")
        guard let url = jsonMockUp else { return }

        let configuration = URLSessionConfiguration.default

        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: url) { [weak self] data, _, error in

//            guard let httpResponse = response as? HTTPURLResponse, (200 ..< 300).contains(httpResponse.statusCode) else {
//                print("--->\(response)")
//                return
//            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ThumbnailInfo.self, from: data)

                self?.thumbnailInfoList.thumbnailInfo = result

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self

        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.estimatedItemSize = .zero
        }
    }

    func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    func topViewUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            // 상단에 서치바 올리기
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.addSearchBar()
            self.view.layoutIfNeeded()
        })
    }

    private func initRefreshControll() {
        collectionView.refreshControl = refreshControll

        refreshControll.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)

        refreshControll.tintColor = .systemGray
        refreshControll.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
    }

    @objc private func refreshCollectionView() {
        print("### \(thumbnailInfoList.thumbnailInfo?.items?.first?.snippet?.channelTitle)")
        getYoutubeData(regionCode: regionCode[ThumbnailController.random].rawValue, apiKey: MediaServiceManager.apiKey)
        print("### \(thumbnailInfoList.thumbnailInfo?.items?.first?.snippet?.channelTitle)")
        collectionView.reloadData()
        refreshControll.endRefreshing()
    }

    private func countFormatting(value: String?) -> String {
        var result = 0.0
        if let value = value {
            guard let item = Double(value) else { return "0" }

            if item < 100_000 {
                result = item / Double(1_000)
                return "\(String(format: "%.1f", result))K"
            } else {
                result = item / Double(100_000)

                return "\(String(format: "%.1f", result))M"
            }
        }
        return "0.9K"
    }
}

extension ThumbnailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = thumbnailInfoList.thumbnailInfo?.items?.count {
            return count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.identifier, for: indexPath) as? ThumbnailCell else { return UICollectionViewCell() }

        let item = thumbnailInfoList.thumbnailInfo?.items?[indexPath.row]

        if let thumbnailImageUrl = item?.snippet?.thumbnails?.high?.url {
            DispatchQueue.main.async {
                cell.imageView.kf.setImage(with: URL(string: thumbnailImageUrl))
            }
        }

        cell.imageView.contentMode = .scaleToFill

        cell.viewCountLabel.text = countFormatting(value: item?.statistics?.viewCount)
        cell.likeCountLabel.text = countFormatting(value: item?.statistics?.likeCount)
        cell.commentCountLabel.text = countFormatting(value: item?.statistics?.commentCount)

        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension ThumbnailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = thumbnailInfoList.thumbnailInfo?.items?[indexPath.row]
        print("### \(item?.snippet?.title)")
//        let vc = DetailController()
//        vc.navigationItem.title = item?.snippet.title
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ThumbnailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 10
        let padding: CGFloat = 10

        let width = (collectionView.bounds.width - interItemSpacing - padding) / 2
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension ThumbnailController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("### \(searchController.searchBar.searchTextField.text)")
    }
}
