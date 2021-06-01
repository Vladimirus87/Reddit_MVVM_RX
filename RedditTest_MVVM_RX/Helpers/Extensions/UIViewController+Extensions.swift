//
//  UIViewController+Extensions.swift
//  TestWorkRaketa
//
//  Created by Vladimirus on 28.10.2020.
//

import UIKit

extension UIViewController {
    func startAnimating() {
        let animateLoading = UIActivityIndicatorView(style: .medium)
        animateLoading.color = .gray
        view.addSubview(animateLoading)
        view.bringSubviewToFront(animateLoading)
        animateLoading.translatesAutoresizingMaskIntoConstraints = false
        animateLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animateLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animateLoading.restorationIdentifier = "loadingView"
        animateLoading.startAnimating()
    }
    
    func stopAnimating() {
        for item in view.subviews
        where item.restorationIdentifier == "loadingView" {
            UIView.animate(withDuration: 0.3, animations: {
                item.alpha = 0
            }) { (_) in
                item.removeFromSuperview()
            }
        }
    }
    
    
}

import RxSwift
import RxCocoa
extension Reactive where Base: UIViewController {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
    
}
