import UIKit
import Networking

public class LibraryList {
  private var navController = UINavigationController()
  private var listVC: ListOfBooksVC?
  
  private lazy var server = AlamofireWebServer(serverURL: "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com")
  private lazy var getBooks = GetBooks.ServerService(server: server)
  
  public init() {
    
  }
  
  public func run(on window: UIWindow) {
    presentListOfBook()
    window.rootViewController = navController
  }
  
  func presentListOfBook() {
    let listOfBooksVC = ListOfBooksVC(getBooks)
    self.listVC = listOfBooksVC
    
    navController.setViewControllers([listOfBooksVC], animated: false)
  }
}
