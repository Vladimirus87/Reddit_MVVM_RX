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
        case serverMessage(String)
        case parseError(String)
    }
    
    public enum APIUrls {
        case topUrl(limit: Int)
        
        var urlString: String {
            switch self {
            case .topUrl(let limit):
                return "https://www.reddit.com/top.json?limit=15\(limit)"
            }
        }
    }
    
    
    public let redditData : BehaviorRelay<[ChildData]> = BehaviorRelay(value: [])
    public let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    public let error : PublishSubject<HomeError> = PublishSubject()
        
    
    public func requestData(isHandleRefresh: Bool = false) {
        guard loading.value == false else { return }
        
        if isHandleRefresh {
            self.redditData.accept([])
        }
        
        print(#function, Thread.current)
        self.loading.accept(true)
        
        var urlString: String = APIUrls.topUrl(limit: 15).urlString
        if let _afterID = redditData.value.last?.name {
            urlString.append("&after="+_afterID)
        }
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: RedditModel.self) { [weak self] (response) in
            self?.loading.accept(false)
                switch response.result {
                case .success(let rData):
                    self?.redditData.accept((self?.redditData.value ?? []) + rData.data.children.map({$0.data}))
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
