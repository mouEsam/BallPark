//
//  WithErrorView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import UIKit

private var errorKey: UInt8 = 0

protocol WithErrorView: UIViewController {}

extension WithErrorView {
    var error: UIView? {
        get { objc_getAssociatedObject(self, &errorKey) as? UIView }
        set { objc_setAssociatedObject(self, &errorKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func showError(message: String, anchorTo anchor: UIView? = nil) {
        guard error == nil else { return }
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
        
        let error = UILabel()
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
        
        view.addSubview(error)
        self.error = error
    }
    
    func hideError() {
        guard let error = error else { return }
        self.error = nil
        error.removeFromSuperview()
    }
}
