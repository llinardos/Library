import UIKit
import Networking

public class LibraryList {
  private var navController = UINavigationController()
  private var listVC: ListOfBooksVC?
  private var detailVC: BookDetailVC?
  
  private lazy var server = AlamofireWebServer(serverURL: "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com")
  private lazy var getBooks = GetBooks.ServerService(server: server)
  
  public init() {}
  
  public func run(on window: UIWindow) {
    presentListOfBook()
    window.rootViewController = navController
  }
  
  func presentListOfBook() {
    let listOfBooksVC = ListOfBooksVC(getBooks)
    self.listVC = listOfBooksVC
    
    listOfBooksVC.didSelectBook = { [unowned self] book in
      self.presentDetailForBook(book)
    }
    
    navController.setViewControllers([listOfBooksVC], animated: false)
  }
  
  func presentDetailForBook(_ book: Book) {
    let detailVC = BookDetailVC(book: book)
    self.detailVC = detailVC
    
    self.navController.pushViewController(detailVC, animated: true)
  }
}
