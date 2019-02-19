//
//  EventPlugins.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 10/02/19.
//

import Foundation

// swiftlint:disable:next identifier_name
public let EventLogger = EventPlugin { Logger.info($0.description) }

public final class EventPlugin: Hashable {
    public let handler: ((EventType) -> Void)

    public init(handler: @escaping ((EventType) -> Void)) {
        self.handler = handler
    }

    public static func == (lhs: EventPlugin, rhs: EventPlugin) -> Bool {
        return lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

public enum EventPlugins {
    public private(set) static var plugins: Set<EventPlugin> = []

    public static func register(plugin: EventPlugin) {
        plugins.insert(plugin)
    }

    public static func remove(plugin: EventPlugin) {
        plugins.remove(plugin)
    }
}
