//
//  AnimeItemCollectionViewCell.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 16/02/19.
//

import Kingfisher
import UIKit

struct AnimeItemViewData {
    var id: String
    var imageUrl: URL?
    var title: String?
    var subtitle: String?
}

class AnimeItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray

        titleLabel.style = Styles.normalCentered
        titleLabel.backgroundColor = backgroundColor
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true

        subtitleLabel.style = Styles.normalCentered
        subtitleLabel.backgroundColor = backgroundColor
        imageView.kf.indicatorType = .activity
    }

    func setup(from item: AnimeItemViewData) {
        imageView.kf.setImage(with: item.imageUrl)
        titleLabel.styledText = item.title
        subtitleLabel.styledText = item.subtitle
    }
}
