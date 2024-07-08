//
//  RankingCell.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var rankingImage: UIImageView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
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
        
        configure(with: rankData)
        rank(at: rankData.rank)
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
}

