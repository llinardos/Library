import UIKit
import Layout

class ListOfBooksView: UIView, BooksShower, UITableViewDelegate, UITableViewDataSource {
  private var tableView = UITableView()
  internal var books: Books
  
  init(books: Books) {
    self.books = books
    
    super.init(frame: .zero)
    
    addSubview(tableView)
    Layout().allign(.all, of: tableView, and: self)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.separatorInset = .zero
    
    BookInListCell.register(on: tableView)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  var didSelectBook: (Book) -> Void = { _ in }
  
  func refresh() {
    self.tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.books.getBooks().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = BookInListCell.dequeueCell(from: tableView)
    let book = self.books.getBooks()[indexPath.row]
    cell.setup(book)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let book = self.books.getBooks()[indexPath.row]
    didSelectBook(book)
  }
}
