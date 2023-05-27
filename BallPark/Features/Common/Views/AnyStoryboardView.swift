//
//  AnyStoryboardView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import UIKit
import Swinject

protocol AnyStoryboardView: UIViewController {
    associatedtype Args
    
    var args: Args! { get set }
    var containerKey: String? { get set }
    var storyboard: UIStoryboard? { get }
    static var storyboardId: String { get }
    func inject(_ container: Container)
}

extension AnyStoryboardView {
    func instantiate<VC, Args>(_ viewType: VC.Type, args: Args? = nil) -> VC where VC: AnyStoryboardView, Args == VC.Args {
        let container = objc_getAssociatedObject(self, &containerKey) as! Container
        return viewType.instantiate(storyboard: storyboard!, container: container)
    }
    
    static func instantiate(storyboard: UIStoryboard, container: Container, args: Args? = nil) -> Self {
        let view = storyboard.instantiateViewController(withIdentifier: Self.storyboardId) as! Self
        view.args = args
        view.associateContainer(container: container)
        return view
    }
    
    func associateContainer(container: Container) {
        objc_setAssociatedObject(self, &containerKey, container, .OBJC_ASSOCIATION_ASSIGN)
        inject(container)
    }
}
