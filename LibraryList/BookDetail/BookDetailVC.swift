import UIKit
import Layout
import SDWebImage

class BookDetailVC: UIViewController {
  private var book: Book
  
  private var photoView = PhotoView(size: 240)
  private var line1 = UILabel()
  private var line2 = UILabel()
  private var line3 = UILabel()
  private var line4 = UILabel()

  init(book: Book) {
    self.book = book
    
    super.init(nibName: nil, bundle: nil)
    
    self.title = book.name
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func loadView() {
    super.loadView()
    
    self.view.backgroundColor = UIColor.white
    
    let labels = [line1, line2, line3, line4]
    labels.forEach({ label in
      label.numberOfLines = 0
      label.textAlignment = .center
      label.lineBreakMode = .byTruncatingTail
      label.textColor = UIColor.black
    })
    var allViews: [UIView] = [photoView]; allViews.append(contentsOf: labels)
    
    let body = UIStackView(arrangedSubviews: allViews)
    body.axis = .vertical
    body.spacing = 8
    
    view.addSubview(body)
    
    Layout().allign([.top, .left, .right], of: body, and: view, toSafeArea: true, insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    
    setup(book)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func setup(_ book: Book) {
    self.line1.text = book.name
    self.line2.text = book.author
    self.line3.text = "\(book.popularity)/100"
    self.line4.text = book.isAvailable ? "Disponible" : "No disponible"
    self.line4.textColor = book.isAvailable ? UIColor.blue : UIColor.red
    self.photoView.setImage(book.imageURL)
  }
}
