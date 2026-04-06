import UIKit

public class PlainHorizontalProgressBar: UIView {
    public var color: UIColor? = .gray {
        didSet { setNeedsDisplay() }
    }
    
    public var maskColor: UIColor? {
        didSet { setNeedsDisplay() }
    }

    public var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    public var isPercentHidden: Bool = true
    public var fontSize: CGFloat = 12

    private let progressLayer = CALayer()
    private let textLayer = CATextLayer()
    private let backgroundMask = CAShapeLayer()

    private var text: String {
        return ""
        return "\(Float(progress).string.originalPriceWithoutCurrency)%"
    }
    private(set) var textSize: CGSize = .zero
    private(set) var textX: CGFloat = 0
    private(set) var textY: CGFloat = 0
    private var textAttributes: [NSAttributedString.Key: Any] {
        [
            .font: UIFont.style(.semibold, fontSize),
            .foregroundColor: UIColor.olchaBlackNeutral,
            .backgroundColor: UIColor.clear
        ]
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayers() {
        layer.addSublayer(progressLayer)
        layer.addSublayer(textLayer)
    }

    public override func draw(_ rect: CGRect) {
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.5).cgPath
        layer.backgroundColor = maskColor?.cgColor
        layer.mask = backgroundMask

        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress / 100, height: rect.height))
        
        progressLayer.frame = progressRect
        progressLayer.cornerRadius = rect.height * 0.5
        progressLayer.backgroundColor = color?.cgColor
        
        //TODO - fix zindex issue with text and progress layer
        guard let context = UIGraphicsGetCurrentContext(), !isPercentHidden else {
            return
        }
        // Set background color
        maskColor?.setFill()
        context.fill(rect)
        textSize = text.size(withAttributes: textAttributes)
        textX = (bounds.width - textSize.width - 8)
        textY = (bounds.height - textSize.height) / 2

        textLayer.string = text as CFTypeRef
        textLayer.font = (textAttributes[.font] as! UIFont) as CFTypeRef
        textLayer.fontSize = (textAttributes[.font] as! UIFont).pointSize
        textLayer.foregroundColor = (textAttributes[.foregroundColor] as! UIColor).cgColor
        textLayer.backgroundColor = (textAttributes[.backgroundColor] as! UIColor).cgColor
        textLayer.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
        textLayer.contentsScale = UIScreen.main.scale
    }
}
