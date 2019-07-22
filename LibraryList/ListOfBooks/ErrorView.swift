import UIKit
import Layout

class ErrorView: UIView {
  private lazy var label = UILabel()
  private lazy var retryButton = UIButton()
  
  public enum ErrorType {
    case noConnection
    case unknown
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    
    retryButton.setTitleColor(UIColor.black, for: .normal)
    
    let content = UIView()
    content.addSubview(label)
    content.addSubview(retryButton)
    
    Layout().allign([.left, .right, .top], of: label, and: content)
    Layout().put(retryButton, at: .bottom, of: label, spacing: 16)
    Layout().allign(.bottom, of: retryButton, and: content)
    Layout().center(retryButton, .horizontally, in: content)
    
    self.addSubview(content)
    Layout().center(content, in: self)
    Layout().allign(.left, of: content, and: self, toSafeArea: true)
  }
  
  func showError(_ error: ErrorType) {
    switch error {
    case .noConnection: label.text = "No internet connection."
    case .unknown: label.text = "Unexpected error."
    }
    retryButton.setTitle("Retry", for: .normal)
    retryButton.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
  }
  
  var onRetryCallback: () -> Void = { }
  
  @objc private func onDismiss() {
    self.onRetryCallback()
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
}
