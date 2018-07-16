//
//  ViewController.swift
//  BabylonHealthDemo
//
//  Created by Benjamin Henshall on 16/07/2018.
//  Copyright © 2018 Benjamin Henshall. All rights reserved.
//

import UIKit
import RealmSwift
import CocoaLumberjackSwift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let testModel = TestModel()
    DDLogInfo(testModel.test)
  }
}

class TestModel: Object {
  // MARK: - Properties
  @objc dynamic var id: Int = 0
  @objc dynamic var test = "test text"
  
  // MARK: - Meta
  override static func primaryKey() -> String? {
    return "id"
  }
}
