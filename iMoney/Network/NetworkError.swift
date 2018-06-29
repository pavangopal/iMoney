//
//  NetworkError.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case IncorrectDataReturned
    case InvalidURL
    case UrlMissing
    case InvalidParameter
    
    case Unknown
}
