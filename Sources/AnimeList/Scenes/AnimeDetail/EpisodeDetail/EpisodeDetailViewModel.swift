//
//  EpisodeDetailViewModel.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 17/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class EpisodeDetailViewModel: AnimeItemDetailViewModel {
    let animeService: AnimeService
    let animeID: String
    let episodeID: String
    init(animeService: AnimeService, animeID: String, episodeID: String) {
        self.animeService = animeService
        self.animeID = animeID
        self.episodeID = episodeID
    }

    lazy var imageUrl: Driver<URL?> = episode.map { $0.imageURL }.asDriver(onErrorJustReturn: nil)

    lazy var title: Driver<String?> = episode.map { $0.name }.asDriver(onErrorJustReturn: nil)

    lazy var titleFull: Driver<String?> = episode.map { "\($0.name)\n\($0.title)"  }.asDriver(onErrorJustReturn: nil)

    lazy var synopsis: Driver<String?> = episode.map { $0.synopsis }.asDriver(onErrorJustReturn: nil)

    lazy var episodesSectionTitle: String = "More Episodes"

    lazy var episode: Observable<EpisodeViewData> = episodes.asObservable()
        .map { [episodeID] episodes in
            return episodes.first { $0.id == episodeID }!
        }

    lazy var episodes: Driver<[EpisodeViewData]> = animeService.getEpisodes(withAnimeID: animeID)
        .asDriver(onErrorJustReturn: [])
        .map { $0.map(EpisodeViewData.init) }
}
