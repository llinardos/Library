import UIKit
import Layout
import SDWebImage

class BookInListCell: UITableViewCell {
  private static var reuseId: String { return String(describing: BookInListCell.self) }
  
  private var photoView = PhotoView(size: 66)
  private var line1 = UILabel()
  private var line2 = UILabel()
  private var line3 = UILabel()
  private var line4 = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    
    let labels = [line1, line2, line3, line4]
    labels.forEach({ label in
      label.numberOfLines = 0
      label.textAlignment = .left
      label.lineBreakMode = .byTruncatingTail
      label.textColor = UIColor.black
    })
    let lines = UIStackView(arrangedSubviews: labels)
    lines.axis = .vertical
  
    let body = UIStackView(arrangedSubviews: [photoView, lines])
    body.axis = .horizontal
    body.spacing = 8
    
    contentView.addSubview(body)
    
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

extension BookInListCell {
  static func register(on tableView: UITableView) {
    tableView.register(BookInListCell.self, forCellReuseIdentifier: BookInListCell.reuseId)
  }
  static func dequeueCell(from tableView: UITableView) -> BookInListCell {
    return tableView.dequeueReusableCell(withIdentifier: BookInListCell.reuseId) as! BookInListCell
  }

}
