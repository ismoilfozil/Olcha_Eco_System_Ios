import UIKit

public final class TimerProgressView: UIView {
    public var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var backColor: UIColor = .hex("#DADADA") {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var maskColor: UIColor? = .olchaPrimaryColor
    public var fontSize: CGFloat = 12 {
        didSet {
            setNeedsDisplay()
        }
    }
    public var lineWidth: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var text: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    private var textSize: CGSize = .zero
    private var textX: CGFloat = 0
    private var textY: CGFloat = 0
    private var textAttributes: [NSAttributedString.Key: Any] {
        [
            .font: UIFont.style(.semibold, fontSize),
            .foregroundColor: UIColor.olchaTextBlack,
            .backgroundColor: UIColor.clear
        ]
    }
    
    private let shapeLayer = CAShapeLayer()
    private let backShapeLayer = CAShapeLayer()
    private let textLayer = CATextLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayer() {
        self.layer.addSublayer(backShapeLayer)
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(textLayer)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2 - lineWidth
        let startAngle: CGFloat = -CGFloat.pi / 2
        let endAngle = startAngle + progress * 2 * CGFloat.pi
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let backPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = maskColor?.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        backShapeLayer.path = backPath.cgPath
        backShapeLayer.fillColor = UIColor.clear.cgColor
        backShapeLayer.strokeColor = backColor.cgColor
        backShapeLayer.lineWidth = lineWidth
        
        textSize = text.size(withAttributes: textAttributes)
        textX = (rect.width / 2) - (textSize.width / 2)
        textY = (rect.height / 2) - (textSize.height / 2)

        textLayer.string = text as CFTypeRef
        textLayer.font = (textAttributes[.font] as! UIFont) as CFTypeRef
        textLayer.fontSize = (textAttributes[.font] as! UIFont).pointSize
        textLayer.foregroundColor = (textAttributes[.foregroundColor] as! UIColor).cgColor
        textLayer.backgroundColor = (textAttributes[.backgroundColor] as! UIColor).cgColor
        textLayer.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
        textLayer.contentsScale = UIScreen.main.scale
    }
}
