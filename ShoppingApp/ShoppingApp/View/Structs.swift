//
//  Structs.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import Foundation

struct Ranking: Codable {
    let high_rating_trend_ranking: RankingInfo
}

struct RankingInfo: Codable {
    let ranking_data: [RankingData]
}

struct RankingData: Codable {
    let rank: Int
    let item_information: ItemInfo
    let image: Image
    let review: Review
    let seller: Seller
}

struct ItemInfo: Codable {
    let name: String
    let url: String
    let regular_price: Int
}

struct Image: Codable {
    let small: String
    let medium: String
}

struct Review: Codable {
    let rate: Double
    let count: Int
    let url: String
}

struct Seller: Codable {
    let name: String
    let url: String
}
