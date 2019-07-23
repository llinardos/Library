class Books {
  private var allBooks: [Book]
  private var processedBooks: [Book] = []
  
  private var getSortMode: () -> SortByPopularity.Mode
  
  init(_ books: [Book] = [], getSortMode: @escaping () -> SortByPopularity.Mode) {
    self.getSortMode = getSortMode
    self.allBooks = books
    self.processBooks()
  }
  
  private func processBooks() {
    switch getSortMode() {
    case .mostPopularAtTop:
      self.processedBooks = allBooks.sorted(by: { (book1, book2) -> Bool in
        book1.popularity > book2.popularity
      })
    case .leastPopularAtTop:
      self.processedBooks = allBooks.sorted(by: { (book1, book2) -> Bool in
        book1.popularity < book2.popularity
      })
    }
  }
  
  func updateBooks(_ books: [Book]) {
    self.allBooks = books
    self.processBooks()
  }
  
  func refresh() {
    self.processBooks()
  }
  
  func getBooks() -> [Book] {
    return processedBooks
  }
  
  func hasContent() -> Bool {
    return allBooks.count > 0
  }
}

