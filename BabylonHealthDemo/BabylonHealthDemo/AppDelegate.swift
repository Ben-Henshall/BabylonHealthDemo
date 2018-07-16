//
//  AppDelegate.swift
//  BabylonHealthDemo
//
//  Created by Benjamin Henshall on 16/07/2018.
//  Copyright © 2018 Benjamin Henshall. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setup()
    return true
  }

  private func setup() {
    setupLogging()
  }

  private func setupLogging() {
    DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
    DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs

    let fileLogger: DDFileLogger = DDFileLogger() // File Logger
    fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    DDLog.add(fileLogger)
  }

}
