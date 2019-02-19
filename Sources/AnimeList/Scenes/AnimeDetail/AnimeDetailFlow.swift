//
//  AnimeDetailFlow.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import Foundation
import RxSwift
import UIKit
import Weakify

class AnimeDetailFlow: FlowCoordinator {
    let animeService: AnimeService
    var root: UIViewController {
        return navigationController
    }

    let navigationController: UINavigationController

    let animeID: String
    init(animeService: AnimeService, navigationController: UINavigationController, animeID: String) {
        self.animeService = animeService
        self.navigationController = navigationController
        self.animeID = animeID
    }

    func handle(deepLink: DeepLink) {
        switch deepLink {
        case let .episode(_, id):
            show(getEpisodeDetailViewController(episodeID: id))
        default:
            break
        }
    }

    func start() -> Completable {
        navigationController.isNavigationBarHidden = false
        let isNavigationControllerEmpty = navigationController.children.isEmpty

        let firstViewController = getAnimeDetailViewController()

        firstViewController.rx.willPopFromParent
            .withUnretained(self)
            .bind(to: didFinish)
            .disposed(by: disposeBag)

        if isNavigationControllerEmpty {
            let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: nil)
            firstViewController.navigationItem.leftBarButtonItem = cancelButton
            cancelButton.rx.tap.withUnretained(self)
                .bind(to: didFinish)
                .disposed(by: disposeBag)
        }
        navigationController.pushViewController(firstViewController, animated: !isNavigationControllerEmpty)
        return .empty()
    }
}

private extension AnimeDetailFlow {
    func getAnimeDetailViewController() -> UIViewController {
        let viewModel = AnimeDetailViewModel(animeService: animeService, animeID: animeID)
        let viewController = Scenes.AnimeDetail.ViewController.animeDetail(viewModel: viewModel, eventHandler: weakify(self, AnimeDetailFlow.handleAnimeItemDetailEvents))
        return viewController
    }

    func getEpisodeDetailViewController(episodeID: String) -> UIViewController {
        let viewModel = EpisodeDetailViewModel(animeService: animeService, animeID: animeID, episodeID: episodeID)
        let viewController = Scenes.AnimeDetail.ViewController.episodeDetail(viewModel: viewModel, eventHandler: weakify(self, AnimeDetailFlow.handleAnimeItemDetailEvents))
        return viewController
    }

    func handleAnimeItemDetailEvents(_ event: AnimeItemDetailEvents) {
        switch event {
        case let .episodeSelected(_, episode):
            show(getEpisodeDetailViewController(episodeID: episode.id))
        }
    }
}
