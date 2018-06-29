//
//  DetailController.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/27/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class DetailController: UIViewController {
    
    lazy var webview:UIWebView = {
        let webview = UIWebView(frame: .zero)
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var url:String?
    private var disposeBag = DisposeBag()
    
    required init(url:String){
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpViews()
        setUpBinding()
        loadWebRequest()
        
    }
    
    func setUpBinding() {
        
        webview.rx.didStartLoad.bind {
            self.activityIndicator.startAnimating()
            }.disposed(by: disposeBag)
        
        webview.rx.didFinishLoad.bind {
            self.activityIndicator.stopAnimating()
            }.disposed(by: disposeBag)
        
        webview.rx.didFailLoad.bind { (error)in
            self.showErrorAlert(message: error.localizedDescription)
            self.activityIndicator.stopAnimating()
        }.disposed(by: disposeBag)
        
    }
    
    func loadWebRequest(){
        guard let urlString = self.url?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),let url =  URL(string: urlString) else{return}
        let urlRequest = URLRequest(url: url)
        webview.loadRequest(urlRequest)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        view.addSubview(webview)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate(
            [
                webview.topAnchor.constraint(equalTo: view.topAnchor),
                webview.leftAnchor.constraint(equalTo: view.leftAnchor),
                webview.rightAnchor.constraint(equalTo: view.rightAnchor),
                webview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                
            ])
    }
    
    func showErrorAlert(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
