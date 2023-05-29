//
//  AnyInstantiableView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import Swinject

protocol AnyInstantiableView: AnyStoryboardView, WithArgs {
    static var storyboardId: String { get }
}

extension AnyInstantiableView {
    func associateArgsWithChildren(args: Args? = nil) {
        for child in children.compactMap({ $0 as? (any WithArgs<Args>) }) {
            var child_ = child
            child_.args = args
        }
    }
    
    func associateArgsWithChild(child: some WithArgs<Args>) {
        var child_ = child
        child_.args = args
    }
    
    static func instantiate(storyboard: UIStoryboard, container: Container, args: Args? = nil) -> Self {
        var view = storyboard.instantiateViewController(withIdentifier: Self.storyboardId) as! Self
        view.args = args
        view.associateContainer(container: container)
        return view
    }
}
