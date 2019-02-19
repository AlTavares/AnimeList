//
//  ApplicationFlow.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import Foundation
import RxSwift
import Weakify

final class ApplicationFlow: FlowCoordinator {
    let animeService = AnimeService()
    var shouldShowOnboarding = false // placeholder

    var root: UIViewController {
        return initialFlow.root
    }

    lazy var initialFlow: FlowCoordinator = getTrendingFlow()

    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func start() -> Completable {
        window.rootViewController = root
        window.makeKeyAndVisible()

        return show(initialFlow)
            .andThen(showOnboardingIfNeeded())
    }

    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .anime(let animeId),
             .episode(let animeId, _):
            let coordinator = Scenes.AnimeDetail.coordinator(animeService: animeService, navigationController: UINavigationController(), animeID: animeId)
            show(coordinator).subscribeCompleted {
                coordinator.handle(deepLink: deepLink)
            }.disposed(by: disposeBag)
        }
    }
}

private extension ApplicationFlow {
    func showOnboardingIfNeeded() -> Completable {
        guard shouldShowOnboarding else {
            return .empty()
        }
        return show(getTrendingFlow())
    }

    func getTrendingFlow() -> FlowCoordinator {
        return Scenes.Trending.coordinator(animeService: animeService)
    }
}
