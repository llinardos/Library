import UIKit

class ListOfBooksVC: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func loadView() {
    super.loadView()
    self.view.backgroundColor = .red
  }
  
}
