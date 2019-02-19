//
//  FlowCoordinator.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 06/02/19.
//

import Foundation
import RxCocoa
import RxSwift

public typealias FlowCoordinator = Coordinator & PresentableCoordinator

public protocol PresentableCoordinator: AnyObject {
    var root: UIViewController { get }
    func start() -> Completable
    func handle(deepLink: DeepLink)
}

open class Coordinator: Hashable {
    var children = Set<Coordinator>()
    var didFinish = PublishRelay<Coordinator>()
    var disposeBag = DisposeBag()

    public static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    deinit {
        Logger.released(self)
    }
}

extension Coordinator {
    func addChild(flow: Coordinator) {
        let itemInserted = children.insert(flow).inserted
        switch itemInserted {
        case true:
            Logger.debug("\(flow) added to \(self) child coordinators")
        case false:
            Logger.warning("\(flow) already child of \(self)")
        }
    }

    func removeChild(flow: Coordinator) {
        let removedItem = children.remove(flow)
        switch removedItem {
        case .none:
            Logger.warning("Couldn't remove coordinator: \(flow). It's not a child coordinator.")
        case .some:
            Logger.debug("Removed \(flow) from \(self) child coordinators")
        }
    }
}

public extension PresentableCoordinator where Self: Coordinator {
    @discardableResult
    func present(_ viewController: UIViewController) -> Completable {
        Logger.verbose("Presenting \(viewController) from \(self):\(root)")
        return root.present(viewController: viewController, animated: true)
    }

    @discardableResult
    func present(_ flow: FlowCoordinator) -> Completable {
        addChild(flow: flow)
        observe(flow: flow)
        guard flow.root != root else {
            return flow.start()
        }
        Logger.verbose("Presenting \(flow) from \(self)")
        return present(flow.root)
    }

    @discardableResult
    func show(_ viewController: UIViewController) -> Completable {
        Logger.verbose("Showing \(viewController) from \(self):\(root)")
        return root.show(viewController)
    }

    @discardableResult
    func show(_ flow: FlowCoordinator) -> Completable {
        addChild(flow: flow)
        observe(flow: flow)
        guard flow.root != root else {
            return flow.start()
        }
        Logger.verbose("Showing \(flow) from \(self)")
        return show(flow.root).andThen(flow.start())
    }

    private func observe(flow: FlowCoordinator) {
        flow.didFinish.map { $0 as? FlowCoordinator }
            .unwrap()
            .withUnretained(self)
            .subscribeNext { this, flow in
                this.finishShowing(flow)
            }.disposed(by: disposeBag)
    }

    @discardableResult
    func finishShowing(_ viewController: UIViewController) -> Completable {
        guard let navigationController = root as? UINavigationController, navigationController.viewControllers.contains(viewController) else {
            return viewController.dismiss(animated: true)
        }
        return navigationController.popViewController()
    }

    @discardableResult
    func finishShowing(_ flow: FlowCoordinator) -> Completable {
        defer { removeChild(flow: flow) }
        guard flow.root != root else {
            return .empty()
        }
        return finishShowing(flow.root)
    }

    func handle(deepLink: DeepLink) {
        Logger.warning("Not implemented")
    }
}
