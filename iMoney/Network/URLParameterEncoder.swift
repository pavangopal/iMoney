//
//  URLParameterEncoder.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

public protocol ParameterEncoder{
    static func encode(request:inout URLRequest,parameters:[String:Any]) throws
}

struct URLParameterEncoder: ParameterEncoder {
    
   public static func encode(request: inout URLRequest, parameters: [String : Any]) throws {
        guard let url = request.url else{throw NetworkError.UrlMissing}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
               urlComponents.queryItems?.append(queryItem)
            }
            
            request.url = urlComponents.url
        }
    }
}
