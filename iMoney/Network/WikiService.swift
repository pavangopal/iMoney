//
//  WikiService.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

import RxSwift

enum Wiki {
    case wikiSearch(query: String,offset:Int)
    
   static var url: String {
        return "https://en.wikipedia.org//w/api.php"
    }
    var parameters:[String:Any]{
        switch self {
        case .wikiSearch(let query, let offset):
            return [
                    "action": "query",
                    "format":"json",
                    "prop":"pageimages|pageterms",
                    "generator":"prefixsearch",
                    "formatversion":"2",
                    "piprop":"thumbnail",
                    "pithumbsize":"50",
                    "pilimit":"10",
                    "wbptterms":"description",
                    "gpssearch":query,
                    "gpslimit":"10",
                    "gpsoffset":"\(offset)"
                    ]
        }
        
    }
}

protocol WikiServicing {
    func userSearch(query: String,offset:Int) -> Observable<WikiSearch> 
}

class WikiService: WikiServicing {
    private let network: Networking
    var offset = 0
    
    init(network: Networking) {
        self.network = network
    }
    
    func userSearch(query: String,offset:Int) -> Observable<WikiSearch> {
        self.offset = self.offset + offset
        
        let url = Wiki.url
        let parameters = Wiki.wikiSearch(query: query, offset: offset).parameters
        
        return network.request(url: url, parameter: parameters)
    }
}

