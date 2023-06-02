//
//  WithEmptyView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import UIKit

typealias EmptyViewKey = UInt8

private var emptyKey: EmptyViewKey = 0

protocol WithEmptyView: UIViewController {}

extension WithEmptyView {
    private func getEmptyView(_ key: UnsafeRawPointer?) -> UIView? {
        if let key = key {
            return objc_getAssociatedObject(self, key) as? UIView
        } else {
            return objc_getAssociatedObject(self, &emptyKey) as? UIView
        }
    }
    
    private func setEmptyView(_ key: UnsafeRawPointer?, _ view: UIView?) {
        if let key = key {
            objc_setAssociatedObject(self, key, view, .OBJC_ASSOCIATION_ASSIGN)
        } else {
            objc_setAssociatedObject(self, &emptyKey, view, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func showEmpty(message: String, anchorTo anchor: UIView? = nil, forKey key: UnsafePointer<EmptyViewKey>? = nil) {
        guard getEmptyView(key) == nil else { return }
        let view = anchor ?? self.view!
        
        let wrapper = UIView()
        view.addSubview(wrapper)
        
        wrapper.layer.masksToBounds = true
        wrapper.layer.cornerRadius = 8
        wrapper.backgroundColor = .red
        wrapper.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.heightAnchor),
            wrapper.widthAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.widthAnchor),
            wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let empty = UILabel()
        empty.numberOfLines = 0
        wrapper.addSubview(empty)
        
        empty.text = message
        empty.textAlignment = .center
        
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.preservesSuperviewLayoutMargins = true
        
        NSLayoutConstraint.activate([
            empty.topAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.topAnchor),
            empty.leadingAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.leadingAnchor),
            empty.trailingAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.trailingAnchor),
            empty.bottomAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.bottomAnchor),
        ])
        
        setEmptyView(key, wrapper)
    }
    
    func hideEmpty(forKey key: UnsafePointer<EmptyViewKey>? = nil) {
        guard let empty = getEmptyView(key) else { return }
        setEmptyView(key, nil)
        empty.removeFromSuperview()
    }
}
