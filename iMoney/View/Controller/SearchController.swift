//
//  SearchController.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchController: UIViewController {
    
    lazy var tableView:UITableView = {
        var tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = Constants.SearchPlaceHolder
        return searchBar
    }()

    lazy var resultLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModeling!
    private var isFromHistory = true
    
    required init(viewModel:SearchViewModeling){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        viewModel = SearchViewModel(network: Network(), wikiService: WikiService(network: Network()))
        setupBindings()
    }
    
    func setUpViews() {
        
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        
        self.navigationItem.titleView = searchBar
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }
    
    func setupBindings() {
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: String(describing:SearchCell.self))

        viewModel.cellModels
            .do(onNext: { (isFromHistoryValueTuple) in
                self.isFromHistory = isFromHistoryValueTuple.0
                print(isFromHistoryValueTuple)
            })
            .map({$0.1 ?? []})
            .bind(to: tableView.rx.items(cellIdentifier: String(describing:SearchCell.self), cellType: SearchCell.self)){ _,cellModel,cell in
                cell.viewModel = cellModel
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map{$0.row}
        .bind(to: viewModel.cellDidSelect)
        .disposed(by: disposeBag)
        
        viewModel.selectedSearch.subscribe(onNext: { (detailViewModel) in
            let controller = DetailController(url: detailViewModel.url)
            self.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        
    }
}

extension SearchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFromHistory{
            let containerView = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
            containerView.backgroundColor = .white
            let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 50))
            containerView.addSubview(titleLabel)
            titleLabel.text = Constants.SearchHistoryTitle
            return containerView
        }else{
            return nil
        }
        
    }
}

