//
//  LayoutConstraint+activate.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 17/02/19.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    @discardableResult
    func activate(priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.priority = priority
        self.isActive = true
        return self
    }
}
