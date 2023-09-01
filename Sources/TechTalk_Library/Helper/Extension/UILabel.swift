import UIKit

class PaddingLabel : UILabel {
    override func drawText(in rect: CGRect) {
         let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
      }
}
