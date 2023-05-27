//
//  InsetsUtils.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    static func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Self {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }
}
