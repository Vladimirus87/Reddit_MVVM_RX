//
//  HomeViewController.swift
//  RedditTest_MVVM_RX
//
//  Created by Vladimirus on 05.02.2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellHeight: CGFloat = 136
    private let redditCellIdentifier = "RedditListCell"
    private let loadingCellIdentifier = "LoadingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    private func setupUI() {
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }

}
