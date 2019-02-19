//
//  Scenes.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 06/02/19.
//

import Foundation
import UIKit

enum Scenes {
    enum Application {
        static func coordinator(window: UIWindow) -> FlowCoordinator {
            return ApplicationFlow(window: window)
        }
    }

    enum Trending {
        static func coordinator(animeService: AnimeService) -> FlowCoordinator {
            return TrendingFlow(animeService: animeService)
        }

        enum ViewController {
            static func trending(viewModel: TrendingViewModel, eventHandler: @escaping ((TrendingViewControllerEvents) -> Void)) -> UIViewController {
                let viewController = TrendingViewController(viewModel: viewModel)
                viewController.events.onNext(eventHandler)
                return viewController
            }
        }
    }

    enum AnimeDetail {
        static func coordinator(animeService: AnimeService, navigationController: UINavigationController, animeID: String) -> FlowCoordinator {
            let forceVerticalFlow = false
            switch forceVerticalFlow {
            case true:
                return AnimeDetailFlow(animeService: animeService, navigationController: UINavigationController(), animeID: animeID)
            case false:
                return AnimeDetailFlow(animeService: animeService, navigationController: navigationController, animeID: animeID)
            }
        }

        enum ViewController {
            static func animeDetail(viewModel: AnimeDetailViewModel, eventHandler: @escaping ((AnimeItemDetailEvents) -> Void)) -> UIViewController {
                let viewController = AnimeItemDetailViewController(viewModel: viewModel)
                viewController.events.onNext(eventHandler)
                return viewController
            }

            static func episodeDetail(viewModel: EpisodeDetailViewModel, eventHandler: @escaping ((AnimeItemDetailEvents) -> Void)) -> UIViewController {
                let viewController = AnimeItemDetailViewController(viewModel: viewModel)
                viewController.events.onNext(eventHandler)
                return viewController
            }
        }
    }
}
