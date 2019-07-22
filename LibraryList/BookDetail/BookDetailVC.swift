import UIKit
import Layout

class BookDetailVC: UIViewController {
  private var book: Book

  init(book: Book) {
    self.book = book
    
    super.init(nibName: nil, bundle: nil)
    
    self.title = book.name
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func loadView() {
    super.loadView()
    
    self.view.backgroundColor = UIColor.white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}
