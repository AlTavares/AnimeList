//
//  AnimeItemDetailViewController.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import AloeStackView
import Foundation
import Kingfisher
import RxCocoa
import RxSwift

protocol AnimeItemDetailViewModel {
    var imageUrl: Driver<URL?> { get }
    var title: Driver<String?> { get }
    var titleFull: Driver<String?> { get }
    var synopsis: Driver<String?> { get }
    var episodes: Driver<[EpisodeViewData]> { get }

    var episodesSectionTitle: String { get }
}

enum AnimeItemDetailEvents: EventType {
    case episodeSelected(viewController: UIViewController, episode: EpisodeViewData)
}

class AnimeItemDetailViewController: ViewController {
    let stackView = AloeStackView()
    let viewModel: AnimeItemDetailViewModel
    let events = EventEmitter<AnimeItemDetailEvents>()
    var disposeBag = DisposeBag()

    let header: UIImageView = {
        var imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 250).activate()
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.style = Styles.headline
        label.numberOfLines = 0
        return label
    }()

    let synopsisLabel: UILabel = {
        let label = UILabel()
        label.style = Styles.normal
        label.numberOfLines = 0
        return label
    }()

    let episodesView = TrendingView()

    init(viewModel: AnimeItemDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        view = stackView
        stackView.addRow(header, animated: true)
        stackView.addRow(titleLabel)
        stackView.addRow(synopsisLabel)
        stackView.addRow(episodesView)

        stackView.setInset(forRow: header, inset: UIEdgeInsets.zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    func setupBindings() {
        episodesView.sectionTitle.styledText = viewModel.episodesSectionTitle

        viewModel.imageUrl.asObservable().withUnretained(header)
            .subscribeNext { header, url in
                header.kf.setImage(with: url)
            }.disposed(by: disposeBag)

        viewModel.title.unwrap().drive(self.rx.title).disposed(by: disposeBag)
        viewModel.titleFull.drive(titleLabel.rx.styledText).disposed(by: disposeBag)
        viewModel.synopsis.drive(synopsisLabel.rx.styledText).disposed(by: disposeBag)

        episodesView.collectionView.registerNib(AnimeItemCollectionViewCell.self)
        viewModel.episodes
            .drive(episodesView.collectionView.rx.items(cellIdentifier: AnimeItemCollectionViewCell.reuseIdentifier, cellType: AnimeItemCollectionViewCell.self)) { _, item, cell in
                cell.setup(from: AnimeItemViewData(item: item))
            }.disposed(by: disposeBag)
        episodesView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        episodesView.collectionView.rx.modelSelected(EpisodeViewData.self)
            .withUnretained(self)
            .map(AnimeItemDetailEvents.episodeSelected)
            .bind(to: events.emitter)
            .disposed(by: disposeBag)

    }
}

extension AnimeItemDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width / 1.3
        return CGSize(width: width, height: height)
    }
}
