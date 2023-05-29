//
//  WithArgsView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation

private var ArgsHandle: UInt8 = 0

protocol WithArgs<Args> {
    associatedtype Args
    
    var args: Args! { get set }
}

extension WithArgs {
    var args: Args! {
        get { objc_getAssociatedObject(self, &ArgsHandle) as? Args }
        set { objc_setAssociatedObject(self, &ArgsHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
