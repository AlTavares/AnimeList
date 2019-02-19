//
//  TrendingViewModel.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import Weakify

class TrendingViewModel {
    let animeService: AnimeService
    init(animeService: AnimeService) {
        self.animeService = animeService
    }

    lazy var trendingWeek: Driver<[AnimeViewData]> = animeService
        .getTrending()
        .asDriver(onErrorJustReturn: [])
        .map { $0.map(AnimeViewData.init) }

    lazy var topAiring: Driver<[AnimeViewData]> = animeService
        .getTopAiring(page: Page(limit: 5, offset: 0))
        .asDriver(onErrorJustReturn: [])
        .map { $0.map(AnimeViewData.init) }

    lazy var topUpcoming: Driver<[AnimeViewData]> = animeService
        .getTopUpcoming(page: Page(limit: 5, offset: 0))
        .asDriver(onErrorJustReturn: [])
        .map { $0.map(AnimeViewData.init) }

    lazy var topRated: Driver<[AnimeViewData]> = animeService
        .getTopRated(page: Page(limit: 5, offset: 0))
        .asDriver(onErrorJustReturn: [])
        .map { $0.map(AnimeViewData.init) }
}
