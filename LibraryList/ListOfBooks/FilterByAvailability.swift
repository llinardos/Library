import UIKit

protocol FilterByAvailabilityGet {
  var currentFilter: FilterByAvailability.Filter { get }
}

class FilterByAvailability: FilterByAvailabilityGet {
  enum Filter {
    case showOnlyAvailables
    case showOnlyNotAvailables
    case showAll
  }
  private(set) var currentFilter: Filter
  
  init(_ initialMode: Filter) {
    self.currentFilter = initialMode
  }
  
  var didSelectFilter: (Filter) -> Void = { _ in }
  
  func presentPicker(over vc: UIViewController) {
    let availablesAction = UIAlertAction(title: "Show Availables" + (currentFilter == .showOnlyAvailables ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentFilter = .showOnlyAvailables
      self.didSelectFilter(self.currentFilter)
    })
    let notAvailablesAction = UIAlertAction(title: "Show Not Availables" + (currentFilter == .showOnlyNotAvailables ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentFilter = .showOnlyNotAvailables
      self.didSelectFilter(self.currentFilter)
    })
    let allAction = UIAlertAction(title: "Show All" + (currentFilter == .showAll ? " ✔︎" : ""), style: .default, handler: { (action) in
      self.currentFilter = .showAll
      self.didSelectFilter(self.currentFilter)
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    let optionsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    optionsAlertController.addAction(availablesAction)
    optionsAlertController.addAction(notAvailablesAction)
    optionsAlertController.addAction(allAction)
    optionsAlertController.addAction(cancelAction)
    vc.present(optionsAlertController, animated: true, completion: nil)
  }
}
