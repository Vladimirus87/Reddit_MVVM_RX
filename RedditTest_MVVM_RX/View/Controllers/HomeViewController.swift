//
//  HomeViewController.swift
//  RedditTest_MVVM_RX
//
//  Created by Vladimirus on 05.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellHeight: CGFloat = 136
    private let redditCellIdentifier = "RedditListCell"
    
    private let childData : PublishSubject<[ChildData]> = PublishSubject()
    private let bag = DisposeBag()
    
    private var viewModel = ViewModel()
    
    private var messageView: MessageView {
        MessageView.sharedInstance
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .gray
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initXibs()
        setupUI()
        setupBinding()
        viewModel.requestData()
    }
    
    
    private func setupBinding() {
        // binding loading to vc
        viewModel.loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: bag)
            
        // observing errors to show
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                DispatchQueue.main.async {
                    self?.messageView.showOnViewWithError(error)
                }
            }).disposed(by: bag)
        
        // observing response
        viewModel.redditData
            .bind(to: tableView.rx.items(cellIdentifier: redditCellIdentifier, cellType: RedditListCell.self)) { row, redditChild, cell in
                cell.updateData(redditChild)
        }.disposed(by: bag)
        
        // observing prefetch
        tableView.rx.prefetchRows
            .observeOn(SerialDispatchQueueScheduler.init(qos: .userInteractive))
            .subscribe(onNext: { [weak self] ips in
                let rows = ips.map({$0.row})
                let last = (self?.viewModel.redditData.value.count ?? 0) - 1
                if rows.contains(last) {
                    self?.viewModel.requestData()
                }
        }).disposed(by: bag)
        
        // observing UITableViewRow selected
        tableView.rx.modelSelected(ChildData.self)
            .subscribe(onNext: { [weak self] item in
                DispatchQueue.main.async {
                    guard let urlString = item.imageUrl else {
                        self?.messageView.showOnView(message: "No any links, try another picture.", theme: .error)
                        return
                    }
                    let availableFormats = ["png", "jpg"]
                    if let format = urlString.split(separator: ".").last,
                       availableFormats.contains(String(format)) {
                        self?.performSegue(withIdentifier: "ToDetailVC", sender: urlString)
                    } else {
                        self?.performSegue(withIdentifier: "toWebVC", sender: urlString)
                    }
                }
        }).disposed(by: bag)
    }
    
    
    private func initXibs() {
        let redditNib = UINib(nibName: redditCellIdentifier, bundle: nil)
        tableView.register(redditNib, forCellReuseIdentifier: redditCellIdentifier)
    }
    
    private func setupUI() {
        title = "Reddit News"
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.addSubview(self.refreshControl)
        tableView.tableFooterView = UIView()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        self.viewModel.requestData(isHandleRefresh: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let urlString = sender as? String else { return }
        if let destinationVC = segue.destination as? DetailViewController {
            destinationVC.imageUrl = urlString
        } else if let destinationVC = segue.destination as? WebViewController {
            destinationVC.urlString = urlString
        }
    }
}
