//
//  MessageView.swift
//  MVVMRx
//
//  Created by Mohammad Zakizadeh on 7/27/18.
//  Copyright © 2018 Storm. All rights reserved.
//

import UIKit


public enum Theme {
    case success
    case warning
    case error
}

class MessageView: UIView {
    
    static var sharedInstance = MessageView()
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet var containerView: UIView!
    
    var parentView: UIView!
    
    private var maskingView : UIView!

    var hideTimer : Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        Bundle.main.loadNibNamed("MessageView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    func showOnView(message:String,theme:Theme){
        parentView = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first//UIApplication.shared.keyWindow
        parentView.addSubview(self)
        addMaskView()
        messageLabel.text = message
        applyTheme(theme: theme)
        self.frame.size = CGSize(width: parentView.frame.width, height: 100)
        self.frame = CGRect(x: parentView.frame.minX, y: parentView.frame.minY - self.frame.height , width: self.frame.width, height: self.frame.height)
        parentView.bringSubviewToFront(self)
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect(x: self.parentView.frame.minX, y: self.parentView.frame.minY, width: self.frame.width, height: self.frame.height)
        }
        makeDim()
        hideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)
    }
    
    func showOnViewWithError(_ error: ViewModel.HomeError) {
        switch error {
        case .parseError(let message):
            self.showOnView(message: message, theme: .error)
        case .serverMessage(let message):
            self.showOnView(message: message, theme: .warning)
        }
    }
    
    private func applyTheme(theme:Theme) {
        var backgroundColor : UIColor
        switch theme {
        case .error:
            backgroundColor = UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        case .success:
            backgroundColor = UIColor(red: 97.0/255.0, green: 161.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        case .warning:
            backgroundColor = UIColor(red: 238.0/255.0, green: 189.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        }
        self.backgroundColor = backgroundColor
    }
    func addMaskView() {
        maskingView = UIView(frame: parentView.bounds)
        parentView.addSubview(maskingView)
        maskingView.backgroundColor = .clear
        maskingView.addTapGestureRecognizer(action: { [weak self] in
            guard let `self` = self else {return}
            self.hideView()
        })
        parentView.addSubview(maskingView)
        maskingView.fillToSuperView()
    }
    func makeDim(){
        self.maskingView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.2, animations: {
            self.maskingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        })
    }
    @objc func hideView(){
        hideTimer.invalidate()
        UIView.animate(withDuration: 0.2, animations: {
            self.maskingView.backgroundColor = .clear
            self.frame.origin.y -= 100
        }) { (_) in
            self.maskingView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}


extension UIView {
    // src : https://medium.com/@sdrzn/adding-gesture-recognizers-with-closures-instead-of-selectors-9fb3e09a8f0b
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    func fillToSuperView(){
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
}
