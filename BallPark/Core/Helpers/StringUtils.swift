//
//  StringUtils.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation

extension String {
    func nilIfEmpty() -> String? {
        if isEmpty { return nil }
        return self
    }
    
    func nilIfBlank() -> String? {
        if trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return nil }
        return self
    }
}
