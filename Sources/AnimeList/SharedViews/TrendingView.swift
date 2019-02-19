//
//  TrendingView.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import UIKit

// swiftlint: disable private_outlet
class TrendingView: UIView, NibInitializable {
    @IBOutlet var contentView: UIView!
    @IBOutlet var sectionTitle: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    private var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
    }

    private func render() {
        loadFromNib()
        sectionTitle.style = Styles.headline
        collectionView.isPagingEnabled = false
        flowLayout.scrollDirection = .horizontal

    }
}


