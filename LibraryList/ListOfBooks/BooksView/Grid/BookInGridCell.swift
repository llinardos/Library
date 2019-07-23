import UIKit
import Layout
import SDWebImage

class BookInGridCell: UICollectionViewCell {
  private static var reuseId: String { return String(describing: BookInGridCell.self) }
  
  private var photoView = PhotoView(size: 120)
  private var line1 = UILabel()
  private var line2 = UILabel()
  private var line3 = UILabel()
  private var line4 = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
 
    let labels = [line1, line2, line3, line4]
    labels.forEach({ label in
      label.numberOfLines = 0
      label.textAlignment = .center
      label.lineBreakMode = .byTruncatingTail
      label.textColor = UIColor.black
    })
    
    var views: [UIView] = [photoView]; views.append(contentsOf: labels)
    let body = UIStackView(arrangedSubviews: views)
    body.axis = .vertical
    
    contentView.addSubview(body)
    
    contentView.layer.borderWidth = 1.0
    contentView.layer.borderColor = UIColor.black.cgColor
    
    Layout().allign(.all, of: body, and: contentView, insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(_ book: Book) {
    self.line1.text = book.name
    self.line2.text = book.author
    self.line3.text = "\(book.popularity)/100"
    self.line4.text = book.isAvailable ? "Disponible" : "No disponible"
    self.line4.textColor = book.isAvailable ? UIColor.blue : UIColor.red
    self.photoView.setImage(book.imageURL)
  }
}

extension BookInGridCell {
  static func register(on collectionView: UICollectionView) {
    collectionView.register(BookInGridCell.self, forCellWithReuseIdentifier: BookInGridCell.reuseId)
  }
  static func dequeueCell(from collectionView: UICollectionView, indexPath: IndexPath) -> BookInGridCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: BookInGridCell.reuseId, for: indexPath) as! BookInGridCell
  }
  
}
