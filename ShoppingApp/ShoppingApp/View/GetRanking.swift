//
//  GetRanking.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import Foundation

class GetRanking {
    let clientID = "dj00aiZpPXZiTk5SdDVkOGl6SyZzPWNvbnN1bWVyc2VjcmV0Jng9MzM-"
    
    func fetchCategoryRanking(for tag: CategoryID, completion: @escaping (RankingInfo) -> Void) {
        guard let url = URL(string: "https://shopping.yahooapis.jp/ShoppingWebService/V1/highRatingTrendRanking?genre_category_id=\(tag.rawValue)&appid=\(clientID)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let resultString = try JSONDecoder().decode(Ranking.self, from: data)
                let result = resultString.high_rating_trend_ranking
                completion(result)
            } catch {
                print("Error in decoding: \(error.localizedDescription)")
                print("Raw data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }
}
