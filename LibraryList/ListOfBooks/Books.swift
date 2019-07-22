class Books {
  enum Mode {
    case byPopularity
  }
  
  private var mode: Mode
  private var allBooks: [Book]
  private var processedBooks: [Book] = []
  
  init(_ books: [Book] = []) {
    self.allBooks = books
    self.mode = .byPopularity
    self.processBooks()
  }
  
  func setMode(_ mode: Mode) {
    self.mode = mode
    self.processBooks()
  }
  
  private func processBooks() {
    switch mode {
    case .byPopularity:
      self.processedBooks = allBooks.sorted(by: { (book1, book2) -> Bool in
        book1.popularity > book2.popularity
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

