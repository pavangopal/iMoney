//
//  SearchCellModel.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchCellModeling {
    var image:Observable<UIImage>{get}
    var title:String{get}
    var description:String{get}
    
}

class SearchCellModel: SearchCellModeling {
    let image: Observable<UIImage>
    let title:String
    let description: String
    
    init(network:Networking,imageUrl:String,title:String,description:String) {
        let placeholder = #imageLiteral(resourceName: "placeHolder")
        self.image = Observable.just(placeholder)
                            .concat(network.image(url: imageUrl))
                            .observeOn(MainScheduler.instance)
                            .catchErrorJustReturn(placeholder)
        self.title = title
        self.description = description
    }
}

