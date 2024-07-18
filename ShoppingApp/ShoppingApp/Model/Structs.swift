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
    let meta: Meta
}

struct Meta: Codable {
    let last_modified: String
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

enum CategoryID: Int, CaseIterable {
    case shopping = 1
    case fashion = 13457
    case food = 2498
    case outdoor = 2513
    case diet = 2500
    case beauty = 2501
    case computer = 2502
    case audio = 2504
    case electoronics = 2505
    case furniture = 2506
    case flower = 2507
    case necessities = 2508
    case tool = 2503
    case pet = 2509
    case handicraft = 2510
    case game = 2511
    case baby = 2497
    case sport = 2512
    case car = 2514
    case record = 2516
    case video = 2517
    case book = 10002
    case rental = 47727
}
