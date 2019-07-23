import UIKit
import Layout

class GridOfBooksView : UIView, BooksShower, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  internal var books: Books
  private var numberOfColumns: Int
  
  var didSelectBook: (Book) -> Void = { _ in }
  
  private lazy var layout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  init(books: Books, numberOfColumns: Int) {
    self.books = books
    self.numberOfColumns = numberOfColumns
    
    super.init(frame: .zero)
    
    addSubview(collectionView)
    Layout().allign(.all, of: collectionView, and: self)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 8
//    layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    BookInGridCell.register(on: collectionView)
    
    self.collectionView.backgroundView = UIView()
    self.collectionView.backgroundColor = UIColor.white
    self.backgroundColor = UIColor.white
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  func refresh() {
    collectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return books.getBooks().count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let book = books.getBooks()[indexPath.row]
    let cell = BookInGridCell.dequeueCell(from: collectionView, indexPath: indexPath)
    cell.setup(book)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let book = books.getBooks()[indexPath.row]
    didSelectBook(book)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    var size = CGSize(width: 0.0, height: 0.0)
    var availableWidth = collectionView.frame.width
    availableWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
    availableWidth -= CGFloat(numberOfColumns - 1)*layout.minimumInteritemSpacing
    size.width = availableWidth/CGFloat(numberOfColumns)
    size.height = 300
    return size
  }
  
}
