//
//  Network.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import RxSwift



protocol Networking {
    func request(url:String,parameter:[String:Any]?) -> Observable<WikiSearch>
    func image(url:String) -> Observable<UIImage>
}

class Network : Networking{
    
    func request(url: String, parameter: [String : Any]?) -> Observable<WikiSearch> {
        return Observable.create({ (observer) -> Disposable in
            
            guard let url = URL(string: url) else{
                observer.onError(NetworkError.InvalidURL)
                return Disposables.create()
            }
            
            var urlRequest = URLRequest(url: url)
            
            try! URLParameterEncoder.encode(request: &urlRequest, parameters: parameter ?? [:])
            
            let dataTask =  URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error{
                    observer.onError(error)
                    return
                }
                
                guard let dataObject = data else {
                    observer.onError(NetworkError.IncorrectDataReturned)
                    return
                }
                
                DispatchQueue.main.async {
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let viewContext = appdelegate.persistentContainer.viewContext
                    
                    let decoder = JSONDecoder()
                    
                    if let context = CodingUserInfoKey.context {
                        decoder.userInfo[context] = viewContext
                    }
                    do{
                        let wikiSearch = try decoder.decode(WikiSearch.self, from: dataObject)
                        observer.onNext(wikiSearch)
                        observer.onCompleted()
                    }catch let error{
                        observer.onError(error)
                    }
                }
              
            }
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        })
    }
    
    func image(url: String) -> Observable<UIImage> {
        
        return Observable.create({ (observer) -> Disposable in
            
            guard let url = URL(string: url) else{
                observer.onError(NetworkError.InvalidURL)
                return Disposables.create()
            }
            
            let dataTask =  URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error{
                    observer.onError(error)
                    return
                }
                
                guard let dataObject = data else {
                    observer.onError(NetworkError.IncorrectDataReturned)
                    return
                }
                guard let image = UIImage(data: dataObject) else {
                    observer.onError(NetworkError.IncorrectDataReturned)
                    return
                }
                
                observer.onNext(image)
                observer.onCompleted()
                
            }
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        })
    }
    
    
}

