//
//  Page+CoreDataClass.swift
//  
//
//  Created by Pavan Gopal on 6/28/18.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
    
}

@objc(Page)
public class Page: NSManagedObject , Codable {
    
    @NSManaged var title : String
    @NSManaged var thumbnail : String?
    @NSManaged var terms : [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case terms
    }
    
    enum ThumbnailNestedKeys: String,CodingKey {
        case source
    }
    enum TermNestedKeys: String,CodingKey {
        case description
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context,let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: Constants.Page, in: managedObjectContext) else {
            
            fatalError("Failed to decode Page!")
        }
        
        self.init(entity: entity, insertInto: nil)
        
        let value = try decoder.container(keyedBy: CodingKeys.self)
        title = try value.decode(String.self, forKey: Page.CodingKeys.title)
        
        if value.contains(Page.CodingKeys.thumbnail){
            let thumnailContainer = try value.nestedContainer(keyedBy: ThumbnailNestedKeys.self, forKey: CodingKeys.thumbnail)
            thumbnail = try thumnailContainer.decodeIfPresent(String.self, forKey: Page.ThumbnailNestedKeys.source)
        }else{
            thumbnail = nil
        }
        
        if value.contains(Page.CodingKeys.terms){
            let termContainer = try value.nestedContainer(keyedBy: TermNestedKeys.self, forKey: CodingKeys.terms)
            terms = try termContainer.decode([String]?.self, forKey: Page.TermNestedKeys.description)
        }else{
            terms = nil
        }
    }
    
}

extension Page{
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: Page.CodingKeys.title)
        
        var thumnailContainer =  container.nestedContainer(keyedBy: ThumbnailNestedKeys.self, forKey: CodingKeys.thumbnail)
        try thumnailContainer.encode(thumbnail, forKey: Page.ThumbnailNestedKeys.source)
        
        var termsContainer = container.nestedContainer(keyedBy: TermNestedKeys.self, forKey: Page.CodingKeys.terms)
        try termsContainer.encode(terms, forKey: TermNestedKeys.description)
    }
}







