//
//  ViewController.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 06/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

open class ViewController: UIViewController {
    open override var description: String {
        return typeName
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        Logger.released(self)
    }
}

public extension UIViewController {
    var typeName: String {
        return String(describing: type(of: self))
    }
}
