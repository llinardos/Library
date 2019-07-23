//
//  Sort.swift
//  LibraryList
//
//  Created by Leandro Linardos on 22/07/2019.
//  Copyright © 2019 Uala. All rights reserved.
//

import UIKit

class SortByPopularity {
  enum Mode {
    case mostPopularAtTop
    case leastPopularAtTop
  }
  private(set) var currentMode: Mode
  
  init(_ initialMode: Mode) {
    self.currentMode = initialMode
  }
  
  var didSelectMode: (Mode) -> Void = { _ in }
  
  func presentPicker(over vc: UIViewController) {
    let mostPopularAction = UIAlertAction(title: "Most popular at top" + (currentMode == .mostPopularAtTop ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentMode = .mostPopularAtTop
      self.didSelectMode(self.currentMode)
    })
    let lessPopularAction = UIAlertAction(title: "Less popular at top" + (currentMode == .leastPopularAtTop ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentMode = .leastPopularAtTop
      self.didSelectMode(self.currentMode)
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    let optionsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    optionsAlertController.addAction(mostPopularAction)
    optionsAlertController.addAction(lessPopularAction)
    optionsAlertController.addAction(cancelAction)
    vc.present(optionsAlertController, animated: true, completion: nil)
  }
}
