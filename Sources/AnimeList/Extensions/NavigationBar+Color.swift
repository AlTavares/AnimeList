//
//  NavigationBar+Color.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 18/02/19.
//

import Foundation
import UIKit

public extension UINavigationBar {
    func setBarColor(_ barColor: UIColor?) {
        guard let barColor = barColor else {
            // restore original nav bar color
            self.setBackgroundImage(nil, for: .default)
            self.hideShadow(false)
            return
        }

        guard barColor.cgColor.alpha != 0 else {
            // if transparent color then use transparent nav bar
            self.setBackgroundImage(UIImage(), for: .default)
            self.hideShadow(true)
            return
        }

        // use custom color
        self.setBackgroundImage(self.image(with: barColor), for: .default)
        self.hideShadow(false)
    }

    private func hideShadow(_ doHide: Bool) {
        self.shadowImage = doHide ? UIImage() : nil
    }

    private func image(with color: UIColor) -> UIImage? {
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(1.0), height: CGFloat(1.0))
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
