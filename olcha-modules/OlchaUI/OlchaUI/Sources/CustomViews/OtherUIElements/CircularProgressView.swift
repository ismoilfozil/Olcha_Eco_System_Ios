import UIKit

public final class CircularProgressView: UIView {
    public var progress: CGFloat = 0.0 {
        didSet {
            setProgressWithAnimation(value: progress)
        }
    }

    public var backColor: UIColor = .hex("#DADADA")

    private var maskColor: UIColor? {
        switch progress {
        case 0...20:
            return .olchaPrimaryColor
        case 20..<100:
            return .bonusProgressColor
        case 100:
            return .olchaGreen
        default: return .olchaPrimaryColor
        }
    }
    public var fontSize: CGFloat = 12
    public var lineWidth: CGFloat = 6

    private var text: String {
        "\(Float(progress).string.originalPriceWithoutCurrency)%"
    }
    private var textSize: CGSize {
        text.size(withAttributes: textAttributes)
    }
    private var textX: CGFloat {
        (frame.width / 2) - (textSize.width / 2)
    }
    private var textY: CGFloat {
        (frame.height / 2) - (textSize.height / 2)
    }
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

    private var viewCenter: CGPoint {
        CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    private var radius: CGFloat {
        min(frame.width, frame.height) / 2 - lineWidth
    }
    private var startAngle: CGFloat {
        -CGFloat.pi / 2
    }
    private var endAngle: CGFloat {
        startAngle + (progress / 100) * 2 * CGFloat.pi
    }
    private var path: UIBezierPath {
        UIBezierPath(
            arcCenter: viewCenter, radius: radius,
            startAngle: startAngle, endAngle: endAngle, clockwise: true
        )
    }
    private var backPath: UIBezierPath {
        UIBezierPath(
            arcCenter: viewCenter, radius: radius,
            startAngle: -CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true
        )
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = path.cgPath
        backShapeLayer.path = backPath.cgPath
        textLayer.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
    }

    private func setupLayer() {
        self.layer.addSublayer(backShapeLayer)
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(textLayer)
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = maskColor?.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round

        backShapeLayer.path = backPath.cgPath
        backShapeLayer.fillColor = UIColor.clear.cgColor
        backShapeLayer.strokeColor = backColor.cgColor
        backShapeLayer.lineWidth = lineWidth
        
        textLayer.string = text as CFTypeRef
        textLayer.font = (textAttributes[.font] as! UIFont) as CFTypeRef
        textLayer.fontSize = (textAttributes[.font] as! UIFont).pointSize
        textLayer.foregroundColor = (textAttributes[.foregroundColor] as! UIColor).cgColor
        textLayer.backgroundColor = (textAttributes[.backgroundColor] as! UIColor).cgColor
        textLayer.contentsScale = UIScreen.main.scale
    }
    
    private func setProgressWithAnimation(duration: TimeInterval = 0.3, value: CGFloat) {
        CATransaction.begin()
        configureFrames()
        configureProgressAnimation(duration: duration, value: value)
        configureTextAnimation(duration: duration)
        CATransaction.commit()
    }
    
    private func configureFrames() {
        shapeLayer.strokeColor = maskColor?.cgColor
        shapeLayer.path = path.cgPath
        backShapeLayer.path = backPath.cgPath
        textLayer.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
    }
    
    private func configureProgressAnimation(duration: TimeInterval, value: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        shapeLayer.strokeEnd = value
        shapeLayer.add(animation, forKey: "animateCircle")
    }
    
    private func configureTextAnimation(duration: TimeInterval) {
        let textAnimation = CAKeyframeAnimation(keyPath: "string")
        textAnimation.duration = duration
        textAnimation.values = generateValues(from: textLayer.string as? String, to: text)
        textAnimation.timingFunctions = Array(repeating: CAMediaTimingFunction(name: .easeInEaseOut), count: textAnimation.values?.count ?? 0)
        
        textLayer.add(textAnimation, forKey: "textAnimation")
        textLayer.string = text as CFTypeRef
    }
    
    private func generateValues(from: String?, to: String) -> [Any]? {
        guard let from = from, !from.isEmpty else { return nil }
        
        let steps = 10 // You can adjust the number of steps
        var values = [Any]()
        
        for i in 0...steps {
            let progress = CGFloat(i) / CGFloat(steps)
            let interpolatedValue = interpolate(from: from, to: to, progress: progress)
            values.append(interpolatedValue)
        }
        
        return values
    }
    
    private func interpolate(from: String, to: String, progress: CGFloat) -> String {
        let fromValue = CGFloat((from as NSString).integerValue)
        let toValue = CGFloat((to as NSString).integerValue)
        let interpolatedValue = fromValue + progress * (toValue - fromValue)
        return "\(Int(interpolatedValue))%"
    }
}
