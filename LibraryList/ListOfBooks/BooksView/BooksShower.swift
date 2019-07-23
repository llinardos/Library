protocol BooksShower {
  var books: Books { set get }
  var didSelectBook: (Book) -> Void { set get }
  func refresh()
}
