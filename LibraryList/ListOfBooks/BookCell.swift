import UIKit

class BookCell: UITableViewCell {
  private static var reuseId: String { return String(describing: BookCell.self) }
  static func register(on tableView: UITableView) {
    tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.reuseId)
  }
  static func dequeueCell(from tableView: UITableView) -> BookCell {
    return tableView.dequeueReusableCell(withIdentifier: BookCell.reuseId) as! BookCell
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(_ book: Book) {
    self.textLabel?.text = "\(book.name) \(book.popularity)"
  }
}
