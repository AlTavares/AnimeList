//
//  AnimeDetailViewModel.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 17/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class AnimeDetailViewModel: AnimeItemDetailViewModel {
    let animeService: AnimeService
    let animeID: String
    init(animeService: AnimeService, animeID: String) {
        self.animeService = animeService
        self.animeID = animeID
    }

    lazy var imageUrl: Driver<URL?> = anime.map { $0.coverUrl }.asDriver(onErrorJustReturn: nil)

    lazy var title: Driver<String?> = anime.map { $0.name }.asDriver(onErrorJustReturn: nil)

    lazy var titleFull: Driver<String?> = title

    lazy var synopsis: Driver<String?> = anime.map { $0.synopsis }.asDriver(onErrorJustReturn: nil)

    lazy var episodesSectionTitle: String = "Episodes"

    lazy var anime: Observable<AnimeViewData> = animeService.getAnime(withID: animeID).asObservable()
        .retry(.exponentialDelayed(maxCount: 3, initial: 1.0, multiplier: 1.0))
        .map(AnimeViewData.init)
        .share(replay: 1, scope: .whileConnected)

    lazy var episodes: Driver<[EpisodeViewData]> = animeService.getEpisodes(withAnimeID: animeID)
        .asDriver(onErrorJustReturn: [])
        .map { $0.map(EpisodeViewData.init) }
}

