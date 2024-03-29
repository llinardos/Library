class Books {
  private var allBooks: [Book]
  private var processedBooks: [Book] = []
  
  private var getSortMode: SortByPopularityGet
  private var getAvailabilityFilter: FilterByAvailabilityGet
  
  init(_ books: [Book] = [], getSortMode: SortByPopularityGet, getAvailabilityFilter: FilterByAvailabilityGet) {
    self.getSortMode = getSortMode
    self.getAvailabilityFilter = getAvailabilityFilter
    self.allBooks = books
    self.processBooks()
  }
  
  private func processBooks() {
    var processedBooks = self.allBooks
    
    switch getAvailabilityFilter.currentFilter {
    case .showAll: break
    case .showOnlyAvailables: processedBooks = processedBooks.filter { $0.isAvailable }
    case .showOnlyNotAvailables: processedBooks = processedBooks.filter { !$0.isAvailable }
    }
    
    switch getSortMode.currentMode {
    case .mostPopularAtTop:
      processedBooks = processedBooks.sorted(by: { (book1, book2) -> Bool in
        book1.popularity > book2.popularity
      })
    case .leastPopularAtTop:
      processedBooks = processedBooks.sorted(by: { (book1, book2) -> Bool in
        book1.popularity < book2.popularity
      })
    }
    
    self.processedBooks = processedBooks
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

