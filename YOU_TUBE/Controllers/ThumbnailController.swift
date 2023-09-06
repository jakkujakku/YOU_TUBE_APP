//
//  ThumbnailController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import Kingfisher
import UIKit

class ThumbnailController: UIViewController {
    private let apiKey = "AIzaSyDiUN58pJ1SBYkxw3G67l250-ZEe_AfzLo"
    private let searchValue = "paka"
    private let jsonMockUp = Bundle.main.url(forResource: "YoutubeMockUp", withExtension: "json")

    @IBOutlet weak var collectionView: UICollectionView!

    var thumbnailInfoList = [ThumbnailInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSearchBar()
        topViewUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        getYoutubeData(searchValue: "paka", apiKey: apiKey)
    }

    func getYoutubeData(searchValue: String, apiKey: String) {
//        let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=100&q=\(searchValue)&key=\(apiKey)")!

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

                if self?.thumbnailInfoList.first?.items.first?.snippet.title != "PAKA" {
                    self?.thumbnailInfoList = [result]
                    self?.thumbnailInfoList[0].items.removeFirst()
                }

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
}

extension ThumbnailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let element = thumbnailInfoList.first?.items.count {
            return element
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.identifier, for: indexPath) as? ThumbnailCell else { return UICollectionViewCell() }

        var item = thumbnailInfoList[0].items[indexPath.row]

        let thumbnailImageUrl = item.snippet.thumbnails.high.url
        DispatchQueue.main.async {
            cell.imageView.kf.setImage(with: URL(string: thumbnailImageUrl))
        }

        cell.imageView.contentMode = .scaleToFill
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension ThumbnailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = thumbnailInfoList.first?.items[indexPath.row]
        let vc = DetailController()
//        vc.navigationItem.title = item?.snippet.title
        navigationController?.pushViewController(vc, animated: true)
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
