//
//  TrendingViewController.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import AloeStackView
import Foundation
import RxCocoa
import RxSwift

enum TrendingViewControllerEvents: EventType {
    case itemSelected(viewController: UIViewController, anime: AnimeViewData)
}

class TrendingViewController: ViewController {
    let viewModel: TrendingViewModel
    let stackView = AloeStackView()
    var disposeBag = DisposeBag()
    let events = EventEmitter<TrendingViewControllerEvents>()

    lazy var rows: [Row] = [
        Row(title: "Trending this week", data: viewModel.trendingWeek),
        Row(title: "Top airing Anime", data: viewModel.topAiring),
        Row(title: "Top upcoming Anime", data: viewModel.topUpcoming),
        Row(title: "Highest rated Anime", data: viewModel.topRated)
    ]

    init(viewModel: TrendingViewModel) {
        self.viewModel = viewModel
        super.init()
        title = "Anime"
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        view = stackView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    func setupBindings() {
        rows.forEach { row in
            row.view.sectionTitle.styledText = row.title
            row.view.collectionView.registerNib(AnimeItemCollectionViewCell.self)
            row.data.drive(row.view.collectionView.rx.items(cellIdentifier: AnimeItemCollectionViewCell.reuseIdentifier, cellType: AnimeItemCollectionViewCell.self)) { _, item, cell in
                cell.setup(from: AnimeItemViewData(item: item))
            }.disposed(by: disposeBag)
            row.view.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
            row.view.collectionView.rx.modelSelected(AnimeViewData.self)
                .withUnretained(self)
                .map(TrendingViewControllerEvents.itemSelected)
                .bind(to: events.emitter)
                .disposed(by: disposeBag)
            stackView.addRow(row.view)
        }
    }
}

extension TrendingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width / 2.3
        return CGSize(width: width, height: height)
    }
}

extension TrendingViewController {
    struct Row {
        var title: String
        var data: Driver<[AnimeViewData]>
        var view: TrendingView = TrendingView()

        init(title: String, data: Driver<[AnimeViewData]>) {
            self.title = title
            self.data = data
        }
    }
}
