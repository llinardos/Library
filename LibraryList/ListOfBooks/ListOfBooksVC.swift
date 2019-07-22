import UIKit
import Layout
import Async

class ListOfBooksVC: UIViewController {
  private var tableView = UITableView()
  private var loadingView = LoadingView()
  private var errorView = ErrorView()
  
  private var getBooks: GetBooks.Service
  private var books = Books()
  
  var didSelectBook: (Book) -> Void = { _ in }
  
  init(_ getBooks: GetBooks.Service) {
    self.getBooks = getBooks
    
    super.init(nibName: nil, bundle: nil)
    
    self.title = "Bienvenido a la biblioteca Ualá"
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func loadView() {
    super.loadView()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.separatorInset = .zero
    
    view.addSubview(tableView)
    Layout().allign(.all, of: tableView, and: view)
    
    view.addSubview(loadingView)
    Layout().allign(.all, of: loadingView, and: view)
    
    view.addSubview(errorView)
    Layout().allign(.all, of: errorView, and: view)
    
    BookCell.register(on: tableView)
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
        self.books = Books(books)
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
    self.tableView.isHidden = true
    self.errorView.isHidden = true
  }
  
  private func showList() {
    self.loadingView.isHidden = true
    self.tableView.isHidden = false
    self.errorView.isHidden = true
    self.tableView.reloadData()
  }
  
  private func showError(_ error: ErrorView.ErrorType) {
    self.loadingView.isHidden = true
    self.tableView.isHidden = true
    self.errorView.isHidden = false
    self.errorView.showError(error)
    self.errorView.onRetryCallback = { [unowned self] in
      self.reloadBooks()
    }
  }
}

extension ListOfBooksVC: UITableViewDelegate, UITableViewDataSource {
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
