//
//  AnyStoryboardView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import UIKit
import Swinject

private var ContainerHandle: UInt8 = 0

protocol AnyStoryboardView: UIViewController {
    
    var storyboard: UIStoryboard? { get }
    func inject(_ container: Container)
}

extension AnyStoryboardView {
    func inject(_ container: Container) {}
    
    func instantiate<VC, Args>(_ viewType: VC.Type, args: Args? = nil) -> VC where VC: AnyInstantiableView, Args == VC.Args {
        let container = objc_getAssociatedObject(self, &ContainerHandle) as! Container
        return viewType.instantiate(storyboard: storyboard!, container: container, args: args)
    }
    
    func associateContainer(container: Container) {
        objc_setAssociatedObject(self, &ContainerHandle, container, .OBJC_ASSOCIATION_ASSIGN)
        inject(container)
    }
}
