//
//  SearchViewModel.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreData

protocol SearchViewModeling{
    
    //MARK:- Input
    var searchText:PublishSubject<String> {get}
    var cellDidSelect: PublishSubject<Int> {get}
    
    //MARK:- Output
    var cellModels: Observable<(Bool,[SearchCellModeling]?)> {get}
    var selectedSearch: Observable<DetailViewModel> {get}
}

class SearchViewModel: SearchViewModeling {
    //MARK:- Input
    var searchText: PublishSubject<String> = PublishSubject<String>()
    var cellDidSelect: PublishSubject<Int> = PublishSubject<Int>()
    
    //MARK:- Output
    var cellModels: Observable<(Bool,[SearchCellModeling]?)>
    var selectedSearch: Observable<DetailViewModel>
    
    private let disposeBag = DisposeBag()
    
    
    init(network:Networking,wikiService:WikiServicing) {
        
        let emptyWikiSearch = WikiSearch.init(query: nil)
        
        let searchResults = searchText
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query) in
                wikiService.userSearch(query: query,offset:0).catchErrorJustReturn(emptyWikiSearch)
            }.observeOn(MainScheduler.instance)
            .startWith(emptyWikiSearch)
            .share(replay: 1)
        
        
        cellModels = searchResults.map({ (wikiSearch) in
            
            //Create Cell-ViewModel based on search
            
            if let query = wikiSearch.query{
                let seachCellModelArray =  query.pages.map({ (page) -> SearchCellModel in
                    let description = page.terms?.joined(separator: ", ") ?? ""
                    let imageUrl = page.thumbnail ?? ""
                    
                    return SearchCellModel(network: network, imageUrl: imageUrl, title: page.title, description: description)
                })
                return (false,seachCellModelArray)
                
            }else{
                //Create Cell-ViewModel based on search History
                let request = NSFetchRequest<Page>.init(entityName: Constants.Page)
                var pages:[Page] = []
                
                do{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    pages = try context.fetch(request)
                    
                }catch{
                    print("Fetching Failed")
                }
                
                let seachCellModelArray = pages.map({ (page) -> SearchCellModel in
                    let description = page.terms?.joined(separator: ", ") ?? ""
                    let imageUrl = page.thumbnail ?? ""
                    
                    return SearchCellModel(network: network, imageUrl: imageUrl, title: page.title, description: description)
                })
                return (true,seachCellModelArray)
            }
        })
        
        selectedSearch = cellDidSelect
            .withLatestFrom(searchResults){ index, result in
                (index,result)
            }.map({ (indexResultTuple) -> DetailViewModel in
                
                let page = indexResultTuple.1.query?.pages[indexResultTuple.0]
                let title = page?.title ?? ""
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                if let selectedPage = page {
                    context.insert(selectedPage)
                    do {
                        try context.save()
                    } catch let error{
                        print("Failed saving with error: \(error.localizedDescription)")
                    }
                }
                return DetailViewModel(title: title)
            })
        
    }
    
}

