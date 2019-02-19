//
//  Reusable.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 06/02/19.
//

import Foundation

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: Reusable {}
extension UITableViewCell: Reusable {}

extension UICollectionView {
    func registerClass(_ cellClasses: AnyClass...) {
        for aClass in cellClasses {
            register(aClass, forCellWithReuseIdentifier: String(describing: aClass))
        }
    }

    func registerNib(_ cellClasses: AnyClass...) {
        for aClass in cellClasses {
            let string = String(describing: aClass); register(UINib(nibName: string, bundle: nil),
                                                              forCellWithReuseIdentifier: string)
        }
    }

    func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        let string = String(describing: cellClass)
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withReuseIdentifier: string, for: indexPath) as! T
    }
}

extension UITableView {
    func registerClass(_ cellClasses: AnyClass...) {
        for aClass in cellClasses {
            register(aClass, forCellReuseIdentifier: String(describing: aClass))
        }
    }

    func registerNib(_ cellClasses: AnyClass...) {
        for aClass in cellClasses {
            let string = String(describing: aClass)
            register(UINib(nibName: string, bundle: nil), forCellReuseIdentifier: string)
        }
    }

    func registerHeaderFooterNib(_ cellClasses: AnyClass...) {
        for aClass in cellClasses {
            let string = String(describing: aClass)
            register(UINib(nibName: string, bundle: nil), forHeaderFooterViewReuseIdentifier: string)
        }
    }

    func dequeue<T: UITableViewCell>(_ cellClass: T.Type, indexPath: IndexPath? = nil) -> T {
        let string = String(describing: cellClass)

        if let indexPath = indexPath {
            // swiftlint:disable:next force_cast
            return dequeueReusableCell(withIdentifier: string, for: indexPath) as! T
        }

        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: string) as! T
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ cellClass: T.Type) -> T {
        let string = String(describing: cellClass)
        // swiftlint:disable:next force_cast
        return dequeueReusableHeaderFooterView(withIdentifier: string) as! T
    }
}
