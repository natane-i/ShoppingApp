//
//  ViewController.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "CategoryIcon", bundle: nil), forCellWithReuseIdentifier: "categoryIcon")
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "RankingCell", bundle: nil), forCellReuseIdentifier: "rankingCell")
            tableView.rowHeight = 125
            tableView.estimatedRowHeight = 125
        }
    }
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var updateAtLabel: UILabel!
    @IBOutlet weak var toInfoView: UIImageView!
    
    let getRanking = GetRanking()
    var rankingData: [RankingData] = []
    var updateDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRanking(tag: .shopping)
        setupGesture()
        // shoppingタグのセルを取得して選択状態にする
        DispatchQueue.main.async {
            if let cell = self.collectionView.cellForItem(at: IndexPath(item: CategoryID.shopping.rawValue - 1, section: 0)) as? CategoryIcon {
                cell.isSelected = true
                print(CategoryID.shopping.rawValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryID.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryIcon", for: indexPath) as! CategoryIcon
        
        let categoryID = CategoryID.allCases[indexPath.item]
        cell.setup()
        cell.categoryLabel.text = fetchTagString(tag: categoryID)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = CategoryID.allCases[indexPath.item]
        
        fetchRanking(tag: selectedCategory)
        
        // 他のタグの選択状態を解除する
        for i in 0..<CategoryID.allCases.count {
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? CategoryIcon {
                cell.isSelected = i == indexPath.item
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingCell
        
        let rankData = rankingData[indexPath.section]
        cell.reloadCell(with: rankData)
        weak var weakSelf = self
        cell.onTapLabel = { [weak weakSelf] url in
            guard let strongSelf = weakSelf else { return }
            let webVC = WebViewController(url: url)
            strongSelf.present(webVC, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rankingData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        toInfoView.addGestureRecognizer(tapGesture)
        toInfoView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let url = "https://developer.yahoo.co.jp/webapi/shopping/shopping/v1/highRatingTrendRanking.html"
        
        if let url = URL(string: url) {
            let webVC = WebViewController(url: url)
            present(webVC, animated: true, completion: nil)
        }
    }
    
    func fetchRanking(tag: CategoryID) {
        getRanking.fetchCategoryRanking(for: tag) { [weak self] result in
            DispatchQueue.main.async {
                self?.rankingData = result.ranking_data
                self?.updateDate = result.meta.last_modified
                if let update = self?.updateDate as? String {
                    self?.formatter(with: update)
                }
                self?.tableView.reloadData()
                if tag == .shopping {
                    self?.tagLabel.text = "総合ランキング"
                } else {
                    self?.tagLabel.text = self?.fetchTagString(tag: tag)
                }
            }
        }
    }
    
    func formatter(with dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy年M月d日"
            let outputDateString = dateFormatter.string(from: date)
            updateAtLabel.text = "更新日：\(outputDateString)"
        }
    }
    
    func fetchTagString(tag: CategoryID) -> String {
        var tagName = ""
        
        switch tag{
        case .shopping:
            tagName = "総合"
        case.fashion:
            tagName = "ファッション"
        case .food:
            tagName = "食品"
        case .outdoor:
            tagName = "アウトドア、釣り、旅行用品"
        case .diet:
            tagName = "ダイエット、健康"
        case .beauty:
            tagName = "コスメ、美容、ヘアケア"
        case .computer:
            tagName = "スマホ、タブレット、パソコン"
        case .audio:
            tagName = "テレビ、オーディオ、カメラ"
        case .electoronics:
            tagName = "家電"
        case .furniture:
            tagName = "家具、インテリア"
        case .flower:
            tagName = "花、ガーデニング"
        case .necessities:
            tagName = "キッチン、日用品、文具"
        case .tool:
            tagName = "DIY、工具"
        case .pet:
            tagName = "ペット用品、生き物"
        case .handicraft:
            tagName = "楽器、手芸、コレクション"
        case .game:
            tagName = "ゲーム、おもちゃ"
        case .baby:
            tagName = "ベビー、キッズ、マタニティ"
        case .sport:
            tagName = "スポーツ"
        case .car:
            tagName = "車、バイク、自転車"
        case .record:
            tagName = "CD、音楽ソフト、チケット"
        case .video:
            tagName = "DVD、映像ソフト"
        case .book:
            tagName = "本、雑誌、コミック"
        case .rental:
            tagName = "レンタル、各種サービス"
        }
        
        return tagName
    }

}



