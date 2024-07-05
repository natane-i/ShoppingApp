//
//  ViewController.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var updateAtLabel: UILabel!
    
    let getRanking = GetRanking()
    var rankingData: [RankingData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RankingCell", bundle: nil), forCellReuseIdentifier: "rankingCell")
        
        tableView.rowHeight = 125
        tableView.estimatedRowHeight = 125
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        fetchRanking()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingCell
        
        let rankData = rankingData[indexPath.row]
        cell.configure(with: rankData)
        print(rankData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingData.count
    }
    
    func fetchRanking() {
        getRanking.fetchRanking() { [weak self] result in
            DispatchQueue.main.async {
                self?.rankingData = result
                self?.tableView.reloadData()
            }
        }
    }
    
    
}

