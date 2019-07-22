import UIKit

public class LibraryList {
  private var navController = UINavigationController()
  private var listVC: ListOfBooksVC?
  
  public init() {
    
  }
  
  public func run(on window: UIWindow) {
    presentListOfBook()
    window.rootViewController = navController
  }
  
  func presentListOfBook() {
    let listOfBooksVC = ListOfBooksVC()
    self.listVC = listOfBooksVC
    
    navController.setViewControllers([listOfBooksVC], animated: false)
  }
}
