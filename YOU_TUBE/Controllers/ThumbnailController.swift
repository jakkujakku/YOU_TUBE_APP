//
//  ThumbnailController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import Kingfisher
import UIKit

private enum RegionCode: String, CaseIterable {
    case kr
    case us
    case fr
    case jp
    case br
    case hk
}

private enum CollectionViewSize: Int {
    case interItemSpacing, padding = 10
    case minimumSpacingSection = 15

    var doubleValue: CGFloat {
        switch self {
        case .interItemSpacing: return 10.0
        case .padding: return 10.0
        case .minimumSpacingSection: return 15.0
        }
    }
}

// MARK: - Main

final class ThumbnailController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControll = UIRefreshControl()

    private var thumbnailInfoList = DataManager.shared

    private let regionCode: [RegionCode] = [.kr, .us, .fr, .jp, .br, .hk]
    private let regionCodeCount = RegionCode(rawValue: RegionCode.kr.rawValue)

    private var isEditMode: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSearchBar()
        topViewUp()
        getYoutubeData(regionCode: regionCode[randomValue()].rawValue, apiKey: SecretKey.apiKey)
        initRefreshControll()
        hideKeyboardWhenTappedAround()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }

    private func getYoutubeData(regionCode: String, apiKey: String) {
//        let url = URL(string: MediaServiceManager.baseURL+regionCode+MediaServiceManager.conditionURL+regionCode+MediaServiceManager.keyURL+SecretKey.apiKey)
        let url = Bundle.main.url(forResource: regionCode, withExtension: "json")

        guard let url = url else { return }

        let configuration = URLSessionConfiguration.default

        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: url) { [weak self] data, response, error in

//            guard let httpResponse = response as? HTTPURLResponse, (200 ..< 300).contains(httpResponse.statusCode) else {
//                print("### \(response)")
//                return
//            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ThumbnailInfo.self, from: data)

                self?.thumbnailInfoList.thumbnailInfo = result
                DataManager.currentRegionCode = regionCode

                DispatchQueue.main.async {
                    self?.navigationItem.title = self?.setupNavigationTitle()
                    self?.collectionView.reloadData()
                }
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false

        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.estimatedItemSize = .zero
        }
    }

    private func setupNavigationTitle() -> String {
        let element = DataManager.currentRegionCode

        switch element {
        case RegionCode.kr.rawValue:
            return "🇰🇷 Korea"
        case RegionCode.us.rawValue:
            return "🇺🇸 America"
        case RegionCode.fr.rawValue:
            return "🇫🇷 France"
        case RegionCode.jp.rawValue:
            return "🇯🇵 Japan"
        case RegionCode.br.rawValue:
            return "🇧🇷 Brazil"
        case RegionCode.hk.rawValue:
            return "🇭🇰 Hong Kong"
        default:
            return "n/a"
        }
    }

    private func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        searchController.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func topViewUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            // 상단에 서치바 올리기
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.addSearchBar()
            self.view.layoutIfNeeded()
        })
    }

    private func randomValue() -> Int {
        let element = Int.random(in: 0 ..< regionCode.count)
        return element
    }

    private func initRefreshControll() {
        collectionView.refreshControl = refreshControll

        refreshControll.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)

        refreshControll.tintColor = .systemGray
        refreshControll.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
    }

    @objc private func refreshCollectionView() {
        getYoutubeData(regionCode: regionCode[randomValue()].rawValue, apiKey: SecretKey.apiKey)

        collectionView.reloadData()
        refreshControll.endRefreshing()
    }
}

// MARK: - UICollectionViewDataSource

extension ThumbnailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEditMode == true {
            return DataManager.filteredItemCount()
        }
        return DataManager.itemCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.identifier, for: indexPath) as? ThumbnailCell else { return UICollectionViewCell() }

        var item: Items?
        item = DataManager.returnItem(for: isEditMode, at: indexPath.row)

        if let thumbnailImageUrl = item?.snippet?.thumbnails?.standard?.url {
            DispatchQueue.main.async {
                cell.imageView.kf.setImage(with: URL(string: thumbnailImageUrl))
            }
        }

        cell.imageView.contentMode = .scaleToFill

        cell.viewCountLabel.text = MediaServiceManager.countFormatting(value: item?.statistics?.viewCount)
        cell.likeCountLabel.text = MediaServiceManager.countFormatting(value: item?.statistics?.likeCount)
        cell.commentCountLabel.text = MediaServiceManager.countFormatting(value: item?.statistics?.commentCount)

        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ThumbnailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = thumbnailInfoList.thumbnailInfo?.items?[indexPath.row]
        let storyboadrd = UIStoryboard(name: "Detail", bundle: nil)
        guard let vc = storyboadrd.instantiateViewController(withIdentifier: "DetailController") as? DetailController else { return }
        vc.videoData = item
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ThumbnailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing = CollectionViewSize.interItemSpacing.doubleValue
        let padding = CollectionViewSize.padding.doubleValue

        let width = (collectionView.bounds.width - interItemSpacing - padding)
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewSize.minimumSpacingSection.doubleValue
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewSize.minimumSpacingSection.doubleValue
    }
}

// MARK: - UISearchResultsUpdating

extension ThumbnailController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        DataManager.filtered = DataManager.searchFilterData(text)
        collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension ThumbnailController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - hideKeyboardWhenTappedAround

extension ThumbnailController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ThumbnailController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
