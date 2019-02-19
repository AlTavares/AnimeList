//
//  RxSwift+Convenience.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 08/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import SwiftRichString

public extension Observable {
    func subscribeNext(_ onNext: ((Element) -> Void)?) -> Disposable {
        return subscribe(onNext: onNext)
    }

    func ensure(_ ensure: @escaping (() -> Void)) -> Observable<Element> {
        return `do`(
            onNext: { _ in
                ensure()
            }, onError: { _ in
                ensure()
        }, onCompleted: ensure)
    }
}

extension PrimitiveSequenceType where TraitType == CompletableTrait, ElementType == Never {
    func subscribeCompleted(_ onCompleted: (() -> Void)?) -> Disposable {
        return subscribe(onCompleted: onCompleted)
    }
}

public extension ObservableType where Self.E == Void {
    func withUnretained<T: AnyObject>(_ obj: T) -> Observable<T> {
        return self.withUnretained(obj) { $0.0 }
    }
}

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    func driveNext(_ onNext: ((Element) -> Void)?) -> Disposable {
        return drive(onNext: onNext)
    }
}

extension Reactive where Base: UILabel {
    /// Bindable sink for `styledText` property.
    public var styledText: Binder<String?> {
        return Binder(self.base) { label, text in
            label.styledText = text
        }
    }
}
