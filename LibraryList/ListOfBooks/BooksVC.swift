import UIKit
import Layout
import Async

class BooksVC: UIViewController {
  private lazy var booksView = BooksView(books: self.books, mode: .grid)
  private var loadingView = LoadingView()
  private var errorView = ErrorView()
  
  private var getBooks: GetBooks.Service
  private lazy var sortByPopularity = SortByPopularity(.mostPopularAtTop)
  private lazy var filterByAvailability = FilterByAvailability(.showAll)
  private lazy var selectView = ShowAsGridOrList(.list)
  private lazy var books = Books(getSortMode: sortByPopularity, getAvailabilityFilter: filterByAvailability)
  
  var didSelectBook: (Book) -> Void = { _ in }
  
  init(_ getBooks: GetBooks.Service) {
    self.getBooks = getBooks
    
    super.init(nibName: nil, bundle: nil)
    
    self.title = "Bienvenido a la biblioteca Ualá"
    
    let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(onSortTap))
    let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterTap))
    self.navigationItem.rightBarButtonItems = [sortButton, filterButton]
    
    let viewButton = UIBarButtonItem(title: "View", style: .plain, target: self, action: #selector(onViewTap))
    self.navigationItem.leftBarButtonItem = viewButton
  }
  
  @objc fileprivate func onSortTap() {
    sortByPopularity.presentPicker(over: self)
  }
  
  @objc fileprivate func onFilterTap() {
    filterByAvailability.presentPicker(over: self)
  }
  
  @objc fileprivate func onViewTap() {
    selectView.presentPicker(over: self)
  }

  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func loadView() {
    super.loadView()
    
    view.addSubview(booksView)
    Layout().allign(.all, of: booksView, and: view)
    
    view.addSubview(loadingView)
    Layout().allign(.all, of: loadingView, and: view)
    
    view.addSubview(errorView)
    Layout().allign(.all, of: errorView, and: view)
    
    self.refreshViewMode()
    
    sortByPopularity.didSelectMode = { [unowned self] _ in
      self.books.refresh()
      self.booksView.refresh()
    }
    filterByAvailability.didSelectFilter = { [unowned self] _ in
      self.books.refresh()
      self.booksView.refresh()
    }
    selectView.didSelectView = { [unowned self] _ in
      self.refreshViewMode()
    }
  }
  
  private func refreshViewMode() {
    switch selectView.currentView {
    case .grid: self.booksView.setMode(.grid)
    case .list: self.booksView.setMode(.list)
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
    self.booksView.isHidden = true
    self.errorView.isHidden = true
  }
  
  private func showList() {
    self.loadingView.isHidden = true
    self.booksView.isHidden = false
    self.errorView.isHidden = true
    self.booksView.refresh()
  }
  
  private func showError(_ error: ErrorView.ErrorType) {
    self.loadingView.isHidden = true
    self.booksView.isHidden = true
    self.errorView.isHidden = false
    self.errorView.showError(error)
    self.errorView.onRetryCallback = { [unowned self] in
      self.reloadBooks()
    }
  }
}
