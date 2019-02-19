//
//  EventEmitter.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 07/02/19.
//

import Foundation
import RxCocoa
import RxSwift

public protocol EventType: CustomStringConvertible {}

public extension EventType {
    var description: String {
        return values.description
    }

    var values: [String: Any] {
        var values = [String: Any]()
        guard let mirror = Mirror(reflecting: self).children.first else { return values }
        values["event"] = mirror.label
        let structMirror = Mirror(reflecting: mirror.value)
        structMirror.children.forEach { child in
            guard let label = child.label else { return }
            values[label] = child.value
        }
        return values
    }
}

public class EventEmitter<Event: EventType> {
    public typealias EventHandler = ((Event) -> Void)
    private var events: PublishRelay<Event> = PublishRelay()
    private var disposeBag = DisposeBag()

    public init() {
        EventPlugins.plugins.forEach { plugin in
            onNext(plugin.handler)
        }
    }

    public func emit(_ event: Event) {
        events.accept(event)
    }

    public var emitter: Binder<Event> {
        return Binder(self) { emitter, event in
            emitter.emit(event)
        }
    }

    public func onNext(_ handler: @escaping EventHandler) {
        events.asSignal().emit(onNext: handler).disposed(by: disposeBag)
    }
}
