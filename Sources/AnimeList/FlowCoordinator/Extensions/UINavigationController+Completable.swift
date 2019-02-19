//
//  UINavigationController+Completable.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 07/02/19.
//

import RxSwift
import UIKit

extension UINavigationController {

    func popViewController() -> Completable {
        guard let viewController = self.topViewController else {
            return .empty()
        }
        defer { self.popViewController(animated: true) }
        return viewController.rx.viewDidDisappear.take(1).asSingle().asCompletable()
    }

}
