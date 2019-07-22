class Books {
  enum SortMode {
    case mostPopularAtTop
    case leastPopularAtTop
  }
  
  private(set) var sortMode: SortMode
  private var allBooks: [Book]
  private var processedBooks: [Book] = []
  
  init(_ books: [Book] = []) {
    self.allBooks = books
    self.sortMode = .mostPopularAtTop
    self.processBooks()
  }
  
  func setSortMode(_ mode: SortMode) {
    self.sortMode = mode
    self.processBooks()
  }
  
  private func processBooks() {
    switch sortMode {
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
  }
  
  func getBooks() -> [Book] {
    return processedBooks
  }
  
  func hasContent() -> Bool {
    return allBooks.count > 0
  }
}

