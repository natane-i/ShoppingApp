//
//  ViewController.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "CategoryIcon", bundle: nil), forCellWithReuseIdentifier: "categoryIcon")
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(UINib(nibName: "RankingCell", bundle: nil), forCellReuseIdentifier: "rankingCell")
            tableView.rowHeight = 125
            tableView.estimatedRowHeight = 125
            tableView.separatorStyle = .none
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
            
        }
    }
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var updateAtLabel: UILabel!
    
    let getRanking = GetRanking()
    var rankingData: [RankingData] = []
    var updateDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRanking(tag: .shopping)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryID.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryIcon", for: indexPath) as! CategoryIcon
        
        cell.setup()
        
        let categoryID = CategoryID.allCases[indexPath.item]
        cell.categoryLabel.text = confirm(tag: categoryID)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = CategoryID.allCases[indexPath.item]
        
        fetchRanking(tag: selectedCategory)
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryIcon {
            cell.isSelected = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingCell
        
        let rankData = rankingData[indexPath.row]
        cell.reloadCell(with: rankData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingData.count
    }
    
    func fetchRanking(tag: CategoryID) {
        getRanking.fetchCategoryRanking(for: tag) { [weak self] result in
            DispatchQueue.main.async {
                self?.rankingData = result.ranking_data
                self?.updateDate = result.meta.last_modified
                self?.updateAtLabel.text = self?.updateDate
                self?.tableView.reloadData()
                self?.tagLabel.text = self?.confirm(tag: tag)
            }
        }
    }
    
    func confirm(tag: CategoryID) -> String {
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
        }
        
        return tagName
    }
    
    
}



