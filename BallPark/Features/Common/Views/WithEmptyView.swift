//
//  WithEmptyView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import UIKit

private var emptyKey: UInt8 = 0

protocol WithEmptyView: UIViewController {}

extension WithEmptyView {
    var empty: UIView? {
        get { objc_getAssociatedObject(self, &emptyKey) as? UIView }
        set { objc_setAssociatedObject(self, &emptyKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func showEmpty(message: String, anchorTo anchor: UIView? = nil) {
        guard empty == nil else { return }
        let view = anchor ?? self.view!
        
        let wrapper = UIView()
        view.addSubview(wrapper)
        
        wrapper.layer.masksToBounds = true
        wrapper.layer.cornerRadius = 8
        wrapper.backgroundColor = .red
        wrapper.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            wrapper.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
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
        
        self.empty = wrapper
    }
    
    func hideEmpty() {
        guard let empty = empty else { return }
        self.empty = nil
        empty.removeFromSuperview()
    }
}