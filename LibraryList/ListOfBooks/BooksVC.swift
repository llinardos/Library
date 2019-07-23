import UIKit
import Layout
import Async

class BooksVC: UIViewController {
  private lazy var listView = ListOfBooksView(books: books)
  private var loadingView = LoadingView()
  private var errorView = ErrorView()
  
  private var getBooks: GetBooks.Service
  private lazy var sortByPopularity = SortByPopularity(.mostPopularAtTop)
  private lazy var filterByAvailability = FilterByAvailability(.showAll)
  private lazy var books = Books(getSortMode: sortByPopularity, getAvailabilityFilter: filterByAvailability)
  
  var didSelectBook: (Book) -> Void = { _ in }
  
  init(_ getBooks: GetBooks.Service) {
    self.getBooks = getBooks
    
    super.init(nibName: nil, bundle: nil)
    
    self.title = "Bienvenido a la biblioteca Ualá"
    
    let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(onSortTap))
    let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterTap))
    self.navigationItem.rightBarButtonItems = [sortButton, filterButton]
  }
  
  @objc fileprivate func onSortTap() {
    sortByPopularity.presentPicker(over: self)
  }
  
  @objc fileprivate func onFilterTap() {
    filterByAvailability.presentPicker(over: self)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func loadView() {
    super.loadView()
    
    view.addSubview(listView)
    Layout().allign(.all, of: listView, and: view)
    
    view.addSubview(loadingView)
    Layout().allign(.all, of: loadingView, and: view)
    
    view.addSubview(errorView)
    Layout().allign(.all, of: errorView, and: view)
    
    sortByPopularity.didSelectMode = { [unowned self] _ in
      self.books.refresh()
      self.listView.refresh()
    }
    filterByAvailability.didSelectFilter = { [unowned self] _ in
      self.books.refresh()
      self.listView.refresh()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if books.hasContent() {
      return
    }
    
    self.reloadBooks()
  }
  
  private func reloadBooks() {
    onMainDo({
      self.showLoading()
    }, onBackgroundDo: { () -> GetBooks.Result in
      return self.getBooks.solve()
    }, thenOnMainDo: { (result) in
      switch result {
      case .success(let books):
        self.books.updateBooks(books)
        self.showList()
      case .failure(let error):
        switch error {
        case .connectionProblem: self.showError(.noConnection)
        case .unexpected: self.showError(.unknown)
        }
      }
    })
  }
  
  private func showLoading() {
    self.loadingView.isHidden = false
    self.listView.isHidden = true
    self.errorView.isHidden = true
  }
  
  private func showList() {
    self.loadingView.isHidden = true
    self.listView.isHidden = false
    self.errorView.isHidden = true
    self.listView.refresh()
  }
  
  private func showError(_ error: ErrorView.ErrorType) {
    self.loadingView.isHidden = true
    self.listView.isHidden = true
    self.errorView.isHidden = false
    self.errorView.showError(error)
    self.errorView.onRetryCallback = { [unowned self] in
      self.reloadBooks()
    }
  }
}

protocol BooksShower {
  var books: Books { set get }
  var didSelectBook: (Book) -> Void { set get }
  func refresh()
}

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
    
    BookCell.register(on: tableView)
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
    let cell = BookCell.dequeueCell(from: tableView)
    let book = self.books.getBooks()[indexPath.row]
    cell.setup(book)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let book = self.books.getBooks()[indexPath.row]
    didSelectBook(book)
  }
}
