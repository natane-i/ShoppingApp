//
//  RankingCell.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import UIKit

class RankingCell: UITableViewCell {
    var onTapLabel: ((URL) -> Void)?
    private var url: URL?
    private var tappableLabels: [UILabel: String] = [:]
    
    @IBOutlet weak var rankingImage: UIImageView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet var stars: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadCell(with rankData: RankingData) {
        rankingLabel.text = "\(rankData.rank)"
        storeLabel.text = rankData.seller.name
        nameLabel.text = rankData.item_information.name
        rateLabel.text = "\(rankData.review.rate)"
        countLabel.text = "(\(formatterNumber(with: rankData.review.count)))"
        priceLabel.text = formatterNumber(with: rankData.item_information.regular_price)
        
        // rankingImageの初期化処理を追加
        rankingImage.tintColor = .clear
        rankingImage.isHidden = false
        
        configure(with: rankData)
        rank(at: rankData.rank)
        
        tappableLabels[nameLabel] = rankData.item_information.url
        tappableLabels[storeLabel] = rankData.seller.url
        tappableLabels[countLabel] = rankData.review.url
        
        setupTapGestures()
        updateStarImage(at: rankData.review.rate)
    }
    
    func updateStarImage(at rating: Double) {
        let roundedRating = round(rating * 2) / 2
        for (index, imageView) in stars.enumerated() {
            let fillLevel = min(1.0, max(0.0, roundedRating - Double(index)))
            if fillLevel == 1.0 {
                imageView.image = UIImage(systemName: "star.fill")
            } else if fillLevel == 0.0 {
                imageView.image = UIImage(systemName: "star.fill")
                imageView.tintColor = UIColor.colorGrayStar
            } else {
                imageView.image = UIImage(named: "image_star_half")
            }
        }
    }

    private func setupTapGestures() {
        for (label, url) in tappableLabels {
            self.url = URL(string: url)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
            
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let urlString = tappableLabels[label], let url = URL(string: urlString) else {
            return
        }
        onTapLabel?(url)
    }
    
    func configure(with rankingData: RankingData) {
        let imageURL = rankingData.image.medium
        guard let url = URL(string: imageURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.productImage.image = image
            }
        }.resume()
    }
    
    func rank(at rankNum: Int) {
        switch rankNum {
        case 1:
            rankingImage.tintColor = UIColor.colorFirst
            rankingLabel.textColor = UIColor.colorFirst
            rankLabel.textColor = UIColor.colorFirst
        case 2:
            rankingImage.tintColor = UIColor.colorSecond
            rankingLabel.textColor = UIColor.colorSecond
            rankLabel.textColor = UIColor.colorSecond
        case 3:
            rankingImage.tintColor = UIColor.colorThird
            rankingLabel.textColor = UIColor.colorThird
            rankLabel.textColor = UIColor.colorThird
        default:
            rankingImage.isHidden = true
            rankingLabel.textColor = UIColor.colorPlaceholder
            rankLabel.textColor = UIColor.colorPlaceholder
        }
    }
    
    func formatterNumber(with number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        let formattedValue = numberFormatter.string(from: NSNumber(value: number)) ?? ""
        return formattedValue
    }
    
}

extension UIColor {
    static var colorFirst: UIColor {
        return UIColor(named: "color_first")!
    }
    
    static var colorSecond: UIColor {
        return UIColor(named: "color_second")!
    }
    
    static var colorThird: UIColor {
        return UIColor(named: "color_third")!
    }
    
    static var colorPlaceholder: UIColor {
        return UIColor(named: "color_placeholder")!
    }
    
    static var colorGrayStar: UIColor {
        return UIColor(named: "color_gray_star")!
    }
}

