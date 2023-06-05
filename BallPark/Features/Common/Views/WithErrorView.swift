//
//  WithErrorView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import UIKit

typealias ErrorViewKey = UInt8

private var errorKey: ErrorViewKey = 0

protocol WithErrorView: UIViewController {}

extension WithErrorView {
    private func getErrorView(_ key: UnsafeRawPointer?) -> UIView? {
        if let key = key {
            return objc_getAssociatedObject(self, key) as? UIView
        } else {
            return objc_getAssociatedObject(self, &errorKey) as? UIView
        }
    }
    
    private func setErrorView(_ key: UnsafeRawPointer?, _ view: UIView?) {
        if let key = key {
            objc_setAssociatedObject(self, key, view, .OBJC_ASSOCIATION_ASSIGN)
        } else {
            objc_setAssociatedObject(self, &errorKey, view, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func showError(message: String, anchorTo anchor: UIView? = nil,
                   addTo superView: UIView? = nil,
                   forKey key: UnsafePointer<ErrorViewKey>? = nil) {
        guard getErrorView(key) == nil else { return }
        let view = anchor ?? self.view!
        let anchorView = superView ?? view
        
        let wrapper = UIView()
        view.addSubview(wrapper)
        
        
        wrapper.layer.masksToBounds = true
        wrapper.layer.cornerRadius = 8
        wrapper.backgroundColor = UIColor(named: "DefaultErrorBackground")
        wrapper.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.preservesSuperviewLayoutMargins = true
        
        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(lessThanOrEqualTo: anchorView.layoutMarginsGuide.heightAnchor),
            wrapper.widthAnchor.constraint(lessThanOrEqualTo: anchorView.layoutMarginsGuide.widthAnchor),
            wrapper.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            wrapper.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor),
        ])
        
        let error = UILabel()
        error.textColor = UIColor(named: "DefaultErrorForeground")
        error.numberOfLines = 0
        wrapper.addSubview(error)
        
        error.text = message
        error.textAlignment = .center
        
        error.translatesAutoresizingMaskIntoConstraints = false
        error.preservesSuperviewLayoutMargins = true
        
        NSLayoutConstraint.activate([
            error.topAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.topAnchor),
            error.leadingAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.leadingAnchor),
            error.trailingAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.trailingAnchor),
            error.bottomAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.bottomAnchor),
        ])
        
        setErrorView(key, wrapper)
    }
    
    func hideError(forKey key: UnsafePointer<ErrorViewKey>? = nil) {
        guard let error = getErrorView(key) else { return }
        setErrorView(key, nil)
        error.removeFromSuperview()
    }
}
