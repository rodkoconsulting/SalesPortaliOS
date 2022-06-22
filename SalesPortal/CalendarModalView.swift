
import Foundation
import UIKit

class CalendarModalView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let layer = self.layer
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOpacity = 0.9;
        
        let roundedRectanglePath = UIBezierPath.init(roundedRect: CGRect(x: 0,y: 20, width: self.frame.size.width, height: self.frame.size.height), cornerRadius: 5)
        let arrowPath = UIBezierPath.init()
        arrowPath.move(to: CGPoint(x: (self.frame.size.width - 40)/2, y: 20))
        arrowPath.addLine(to: CGPoint(x: self.frame.size.width/2, y: 0))
        arrowPath.addLine(to: CGPoint(x: (self.frame.size.width - 40)/2 + 40, y: 20))
        
        let context = UIGraphicsGetCurrentContext();
        context?.setAlpha(1.0)
        context?.setFillColor(UIColor.blue.cgColor)
        context?.setLineWidth(0)
        
        roundedRectanglePath.append(arrowPath)
        context?.addPath(roundedRectanglePath.cgPath);
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}
