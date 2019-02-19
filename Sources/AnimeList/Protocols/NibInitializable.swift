//
//  NibInitializable.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 06/02/19.
//

import Foundation
import UIKit

protocol NibInitializable {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var contentView: UIView! { get }
}

extension NibInitializable where Self: UIView {
    func loadFromNib(named: String? = nil) {
        let nibName = named ?? String(describing: type(of: self))
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        contentView.backgroundColor = UIColor.clear
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
