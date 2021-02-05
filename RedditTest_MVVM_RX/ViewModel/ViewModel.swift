//
//  ViewModel.swift
//  RedditTest_MVVM_RX
//
//  Created by Vladimirus on 05.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class ViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
        case parseError(String)
    }
    
    public enum APIUrls {
        static let topUrl = "https://www.reddit.com/top.json?limit=15"
    }
    
    
    public let redditData : PublishSubject<RedditModel> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
        
    
    public func requestData() {
        self.loading.onNext(true)
        AF.request(APIUrls.topUrl)
            .validate()
            .responseDecodable(of: RedditModel.self) { [weak self] (response) in
            self?.loading.onNext(false)
                switch response.result {
                case .success(let rData):
                    self?.redditData.onNext(rData)
                case .failure(let error):
                    switch error.responseCode {
                    case 404:
                        self?.error.onNext(.serverMessage("Not Found"))
                    default:
                        if error.isResponseSerializationError {
                            self?.error.onNext(.parseError("Sorry, parsing error"))
                        } else {
                            self?.error.onNext(.serverMessage(error.localizedDescription))
                        }
                    }
                    
                }
            
            
        }
        
    }
    
}
