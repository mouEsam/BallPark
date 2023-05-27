//
//  AnyInstantiableView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import Swinject

protocol AnyInstantiableView: AnyStoryboardView {
    associatedtype Args
    
    var args: Args! { get set }
    static var storyboardId: String { get }
}

extension AnyInstantiableView {
    static func instantiate(storyboard: UIStoryboard, container: Container, args: Args? = nil) -> Self {
        let view = storyboard.instantiateViewController(withIdentifier: Self.storyboardId) as! Self
        view.args = args
        view.associateContainer(container: container)
        return view
    }
}
