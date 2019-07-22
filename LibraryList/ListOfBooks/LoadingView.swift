import UIKit
import Layout

class LoadingView: UIView {
  private var spinner = UIActivityIndicatorView(style: .white)
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    spinner.color = UIColor.black
    addSubview(spinner)
    Layout().center(spinner, in: self)
    
    self.backgroundColor = UIColor.white
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    spinner.startAnimating()
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
}
