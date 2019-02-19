//
//  UINavigationController+Completable.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 07/02/19.
//

import RxCocoa
import RxSwift
import RxViewController
import UIKit

extension UIViewController {
    func show(_ viewController: UIViewController) -> Completable {
        defer { self.show(viewController, sender: nil) }
        return viewController.rx.viewDidAppear.take(1).asSingle().asCompletable()
    }

    func dismiss(animated: Bool) -> Completable {
        defer { self.dismiss(animated: animated, completion: nil) }
        return self.rx.viewDidDisappear.take(1).asSingle().asCompletable()
    }

    func present(viewController: UIViewController, animated: Bool) -> Completable {
        defer { self.present(viewController, animated: animated, completion: nil) }
        return viewController.rx.viewDidAppear.take(1).asSingle().asCompletable()
    }
}

public extension Reactive where Base: UIViewController {
    var willPopFromParent: Observable<Void> {
        return willMoveToParentViewController.filter { $0 == nil }.mapTo(())
    }
}
