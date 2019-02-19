//
//  TrendingFlow.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import Weakify

class TrendingFlow: FlowCoordinator {
    let animeService: AnimeService
    var root: UIViewController {
        return navigationController
    }

    private lazy var navigationController: UINavigationController = UINavigationController(rootViewController: initialViewController)
    private lazy var initialViewController = getTrendingViewController()

    init(animeService: AnimeService) {
        self.animeService = animeService
    }

    func start() -> Completable {
        initialViewController.rx.viewWillAppear.withUnretained(navigationController).subscribeNext { navigationController, _ in
            navigationController.isNavigationBarHidden = true
        }.disposed(by: disposeBag)

        return .empty()
    }
}

private extension TrendingFlow {
    func getTrendingViewController() -> UIViewController {
        let viewModel = TrendingViewModel(animeService: animeService)
        return Scenes.Trending.ViewController.trending(viewModel: viewModel, eventHandler: weakify(self, TrendingFlow.trendingEventHandler))
    }

    func trendingEventHandler(event: TrendingViewControllerEvents) {
        switch event {
        case .itemSelected(_, let anime):
            Logger.debug(anime)
            show(getAnimeFlow(animeID: anime.id))
        }
    }

    func getAnimeFlow(animeID: String) -> FlowCoordinator {
        return Scenes.AnimeDetail.coordinator(animeService: animeService, navigationController: navigationController, animeID: animeID)
    }
}
