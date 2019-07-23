import UIKit

class ShowAsGridOrList {
  enum View {
    case grid
    case list
  }
  private(set) var currentView: View
  
  init(_ initialMode: View) {
    self.currentView = initialMode
  }
  
  var didSelectView: (View) -> Void = { _ in }
  
  func presentPicker(over vc: UIViewController) {
    let gridAction = UIAlertAction(title: "Show as Grid" + (currentView == .grid ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentView = .grid
      self.didSelectView(self.currentView)
    })
    let listAction = UIAlertAction(title: "Show as List" + (currentView == .list ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentView = .list
      self.didSelectView(self.currentView)
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    let optionsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    optionsAlertController.addAction(gridAction)
    optionsAlertController.addAction(listAction)
    optionsAlertController.addAction(cancelAction)
    vc.present(optionsAlertController, animated: true, completion: nil)
  }
}
