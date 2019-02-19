//
//  FlowCoordinatorTests.swift
//  FlowCoordinatorTests
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

@testable import AnimeList
import RxSwift
import XCTest

class FlowCoordinatorTest: XCTestCase {
    var window: UIWindow!
    var mainFlow: MainFlowCoordinator!

    override func setUp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = window
        mainFlow = MainFlowCoordinator(window: window)
    }

    func testHorizontalFlow() {
        let childFlow = ChildFlowCoordinator(navigationController: mainFlow.navigationController)

        let childShown = expectation(description: "Child shown")
        _ = mainFlow.start()
            .andThen(mainFlow.show(childFlow))
            .subscribeCompleted {
                childShown.fulfill()
            }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(mainFlow.navigationController, childFlow.root)
        XCTAssertTrue(mainFlow.children.contains(childFlow))
        XCTAssertTrue(childFlow.navigationController.children.contains(childFlow.firstViewController))

        let childFinishedShowing = expectation(description: "Child finished showing")

        _ = mainFlow.finishShowing(childFlow).subscribeCompleted {
            childFinishedShowing.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertFalse(mainFlow.children.contains(childFlow))
    }

    func testVerticalFlow() {
        let childFlow = ChildFlowCoordinator(navigationController: UINavigationController())

        let childShown = expectation(description: "Child shown")

        _ = mainFlow.start()
            .andThen(mainFlow.show(childFlow))
            .subscribeCompleted {
                childShown.fulfill()
            }

        waitForExpectations(timeout: 1)
        XCTAssertNotEqual(mainFlow.navigationController, childFlow.root)
        XCTAssertFalse(mainFlow.navigationController.children.contains(childFlow.firstViewController))

        let childFinishedShowing = expectation(description: "Child finished showing")

        _ = mainFlow.finishShowing(childFlow).subscribeCompleted {
            childFinishedShowing.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertFalse(mainFlow.children.contains(childFlow))
    }
}

class MainFlowCoordinator: FlowCoordinator {
    var root: UIViewController {
        return navigationController
    }

    lazy var navigationController = UINavigationController(rootViewController: firstViewController)

    var firstViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        return vc
    }()

    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func start() -> Completable {
        window.rootViewController = root
        window.makeKeyAndVisible()
        return .empty()
    }
}

class ChildFlowCoordinator: FlowCoordinator {
    var root: UIViewController {
        return navigationController
    }

    var firstViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        return vc
    }()

    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    func start() -> Completable {
        return show(firstViewController)
    }
}
