//
//  AppDelegate.swift
//  AnimeList
//
//  Created by Alexandre Mantovani Tavares on 05/02/19.
//  Copyright © 2019 Alexandre Mantovani Tavares. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: FlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        EventPlugins.register(plugin: EventLogger)
        Styles.setup()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = Scenes.Application.coordinator(window: window)
        self.window = window
        self.appCoordinator = appCoordinator
        _ = appCoordinator.start()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let deeplink = DeepLinkParser().parse(url.absoluteString)
        if let deeplink = deeplink {
            appCoordinator?.handle(deepLink: deeplink)
        }
        return deeplink != nil
    }
}

