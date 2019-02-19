//
//  Styles.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 08/02/19.
//

import Foundation
import SwiftRichString

enum Styles {

    static func setup() {
        UINavigationBar.appearance().tintColor = UIColor.black
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }

    static var normal: Style {
        return Style { item in
            item.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            item.minimumLineHeight = 24
            item.color = UIColor.darkText
            item.alignment = .justified
        }
    }

    static var normalCentered: Style {
        return normal.byAdding { item in
            item.alignment = .center
        }
    }

    static var headline: Style {
        return Style { item in
            item.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
            item.minimumLineHeight = 38
            item.color = UIColor.darkText
            item.alignment = .left
        }
    }

    static var headlineCentered: Style {
        return headline.byAdding { item in
            item.alignment = .center
        }
    }

    static var buttonTitle: Style {
        return Style { item in
            item.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            item.color = UIColor.black
            item.alignment = .center
        }
    }
}
