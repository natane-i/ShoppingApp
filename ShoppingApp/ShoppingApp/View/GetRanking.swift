//
//  GetRanking.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import Foundation

class GetRanking {
    let clientID = "dj00aiZpPXZiTk5SdDVkOGl6SyZzPWNvbnN1bWVyc2VjcmV0Jng9MzM-"
    
    func fetchRanking(completion: @escaping ([RankingData]) -> Void) {
        guard let url = URL(string: "https://shopping.yahooapis.jp/ShoppingWebService/V1/highRatingTrendRanking?appid=\(clientID)") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let resultString = try JSONDecoder().decode(Ranking.self, from: data)
                let result = resultString.high_rating_trend_ranking.ranking_data
                completion(result)
            } catch {
                print("Error in decoding: \(error.localizedDescription)")
                print("Raw data: \(String(data: data, encoding: .utf8) ?? "")")
                completion([])
            }
        }.resume()
    }
    
}
