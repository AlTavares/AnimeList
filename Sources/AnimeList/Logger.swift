//
//  Logger.swift
//  AnimeListCore
//
//  Created by Alexandre Mantovani Tavares on 05/02/19.
//

import Foundation
import SwiftyBeaver

// swiftlint:disable:next identifier_name
public let Logger: SwiftyBeaver.Type = {
    let log = SwiftyBeaver.self
    let consoleDestination = ConsoleDestination()
    #if DEBUG
    consoleDestination.minLevel = .verbose
    consoleDestination.asynchronously = false
    #else
    consoleDestination.minLevel = .warning
    #endif
    log.addDestination(consoleDestination)

    let file = FileDestination()
    file.logFileURL = URL(fileURLWithPath: "/tmp/flowcoordinator.log")
    file.format = "$C$L$c: $M"
    log.addDestination(file)
    return log
}()

public extension SwiftyBeaver {
    static func released(_ caller: Any,
                         file: String = #file,
                         line: Int = #line,
                         function: String = #function) {
        debug("\(type(of: caller.self)) released from memory", file, function, line: line)
    }

    static func ifNil<T>(_ caller: T?,
                         description: String? = nil,
                         file: String = #file,
                         line: Int = #line,
                         function: String = #function) -> T? {
        if caller == nil {
            let prepend = description ?? ""
            warning("\(prepend): \(type(of: caller.self)) is nil", file, function, line: line)
        }
        return caller
    }

}
