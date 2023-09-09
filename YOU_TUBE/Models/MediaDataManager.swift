//
//  MediaDataManager.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/08.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    static var filtered = [Items]()
    static var currentRegionCode = ""

    var thumbnailInfo: ThumbnailInfo?

    static func returnItem(for editMode: Bool, at index: Int) -> Items {
        if editMode == true {
            return filtered[filteredItemIndex(for: index)]
        } else {
            return (shared.thumbnailInfo?.items?[sharedItemIndex(for: index)])!
        }
    }

    static func sharedItemIndex(for index: Int) -> Int {
        return index
    }

    static func filteredItemIndex(for index: Int) -> Int {
        if index > filtered.count {
            return 0
        }
        return index
    }

    static func itemCount() -> Int {
        guard let itemCount = DataManager.shared.thumbnailInfo?.items?.count else { return 0 }
        return itemCount
    }

    static func filteredItemCount() -> Int {
        return DataManager.filtered.count
    }

    static func searchFilterData(_ keyword: String) -> [Items] {
        if let data = DataManager.shared.thumbnailInfo?.items?.filter { $0.snippet?.title?.contains(keyword) == true } {
            return data
        }
        return []
    }
}
