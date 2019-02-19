//
//  AnimeService.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 05/02/19.
//

import Foundation
import Nappa
import RxSwift

public class AnimeService {
    private enum Constants {
        enum URLs {
            static let host: URL = URL(string: "https://kitsu.io/api/edge")!
            static let anime: URL = host.appendingPathComponent("anime")
            static let episodes: URL = host.appendingPathComponent("episodes")
            static let trending: URL = host.appendingPathComponent("trending/anime")
        }
    }

    private let service: HTTPService
    public init(service: HTTPService = HTTPService()) {
        self.service = service
    }

    private func merge(parameters: [APIParameter]) -> [String: Encodable] {
        var mergedParameters = [String: Encodable]()
        parameters.forEach { parameter in
            mergedParameters.merge(parameter.parameters) { $1 }
        }
        return mergedParameters
    }

    func getAnimeList(_ apiParameters: APIParameter...) -> Single<[Anime]> {
        let parameters = merge(parameters: apiParameters)
        return Single.create { single in
            self.service.request(method: .get, url: Constants.URLs.anime.absoluteString, payload: parameters).responseObject(keyPath: "data") { (response: ObjectResponse<[Anime]>) in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                    Logger.debug("\(value.count) items loaded")
                case .failure(let error):
                    Logger.error(error)
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func getTrending(limit: Int = 5) -> Single<[Anime]> {
        let parameters = ["limit": limit]
        return Single.create { single in
            self.service.request(method: .get, url: Constants.URLs.trending.absoluteString, payload: parameters).responseObject(keyPath: "data") { (response: ObjectResponse<[Anime]>) in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                    Logger.debug("\(value.count) items loaded")
                case .failure(let error):
                    Logger.error(error)
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func getAnime(withID id: String) -> Single<Anime> {
        let url = Constants.URLs.anime.appendingPathComponent(id).absoluteString
        return Single.create { single in
            self.service.request(method: .get, url: url).responseObject(keyPath: "data") { (response: ObjectResponse<Anime>) in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                    Logger.debug("\(value.attributes.canonicalTitle) loaded")
                case .failure(let error):
                    Logger.error(error)
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func getEpisodes(withAnimeID id: String) -> Single<[Episode]> {
        let filter = Filter(mediaId: id)
        let sort = Sort(sortField: .number, order: .increasing)
        let parameters = merge(parameters: [filter, sort])
        return Single.create { single in
            self.service.request(method: .get, url: Constants.URLs.episodes.absoluteString, payload: parameters).responseObject(keyPath: "data") { (response: ObjectResponse<[Episode]>) in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                    Logger.debug("\(value.count) items loaded")
                case .failure(let error):
                    Logger.error(error)
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func getTopAiring(page: Page) -> Single<[Anime]> {
        let filter = Filter(status: .current)
        let sort = Sort(sortField: .userCount, order: .decreasing)
        return getAnimeList(page, filter, sort)
    }

    func getTopUpcoming(page: Page) -> Single<[Anime]> {
        let filter = Filter(status: .upcoming)
        let sort = Sort(sortField: .userCount, order: .decreasing)
        return getAnimeList(page, filter, sort)
    }

    func getTopRated(page: Page) -> Single<[Anime]> {
        let sort = Sort(sortField: .averageRating, order: .decreasing)
        return getAnimeList(page, sort)
    }
}
