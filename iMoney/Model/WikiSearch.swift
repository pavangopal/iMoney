//
//  WikiSearch.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import CoreData

struct WikiSearch:Codable {
    
    let query : WikiSearchQuery?
    
}

struct WikiSearchQuery:Codable {
    let pages : [Page]
}

