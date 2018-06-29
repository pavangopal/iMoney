//
//  DetailViewModel.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation


struct DetailViewModel{
    
    let title:String
    let url:String
    
    init(title:String) {
        self.title = title
        
        var words = [String]()
        let range = title.startIndex..<title.endIndex
        title.enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) in
            if let substringD = substring{
                words.append(substringD)
            }
        }
        
        self.url = Constants.wikiBaseUrl +  words.joined(separator: "_")
    }
    
}
