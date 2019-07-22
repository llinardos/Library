import UIKit
import SDWebImage
import Layout

class PhotoView: UIView { // TODO: move to a more reusable place (is not noly related no ListOfBooks).
  private var photoView = UIImageView()
  private var spinner = UIActivityIndicatorView(style: .gray)
  
  init(size: CGFloat) {
    super.init(frame: .zero)
    
    photoView.contentMode = .scaleAspectFit
    photoView.clipsToBounds = true
    
    let container = UIStackView(arrangedSubviews: [photoView])
    container.alignment = .center
    container.axis = .horizontal
    
    self.addSubview(container)
    Layout().allign(.all, of: container, and: self)
    
    self.addSubview(spinner)
    Layout().center(spinner, in: self)
    
    Layout().size(.width, of: photoView, is: size)
    Layout().size(.height, of: photoView, is: size)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  func setImage(_ url: URL) {
    spinner.startAnimating()
    photoView.backgroundColor = .clear
    photoView.sd_setImage(with: url) { (_, error, _, _) in
      self.spinner.stopAnimating()
      if error != nil {
        self.photoView.backgroundColor = .lightGray
      }
    }
  }
}
