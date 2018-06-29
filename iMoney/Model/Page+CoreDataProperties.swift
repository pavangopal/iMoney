//
//  Page+CoreDataProperties.swift
//  
//
//  Created by Pavan Gopal on 6/28/18.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: Constants.Page)
    }

}
