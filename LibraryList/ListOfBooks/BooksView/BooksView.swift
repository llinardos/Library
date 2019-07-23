import Foundation
import Layout

class BooksView: UIView, BooksShower {
  internal var books: Books
  private lazy var listView = ListOfBooksView(books: self.books)
  private lazy var gridView = GridOfBooksView(books: self.books, numberOfColumns: 2)
  
  enum Mode {
    case list, grid
  }
  private var mode: Mode
  
  var didSelectBook: (Book) -> Void = { _ in }
  
  func refresh() {
    listView.refresh()
    gridView.refresh()
  }
  
  init(books: Books, mode: Mode) {
    self.books = books
    self.mode = mode
    
    super.init(frame: .zero)
    
    addSubview(gridView)
    addSubview(listView)
    Layout().allign(.all, of: gridView, and: self)
    Layout().allign(.all, of: listView, and: self)
    
    self.listView.didSelectBook = { [unowned self] book in self.didSelectBook(book) }
    self.gridView.didSelectBook = { [unowned self] book in self.didSelectBook(book) }
    
    setMode(mode)
  }
  
  func setMode(_ mode: Mode) {
    self.mode = mode
    switch mode {
    case .grid: self.gridView.isHidden = false
    case .list: self.gridView.isHidden = true
    }
    self.listView.isHidden = !self.gridView.isHidden
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
}
