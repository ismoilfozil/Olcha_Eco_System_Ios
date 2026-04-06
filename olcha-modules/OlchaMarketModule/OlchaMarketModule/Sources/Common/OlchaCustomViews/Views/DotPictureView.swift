//
//  DotPictureView.swift
//  Week_help
//
//  Created by Elbek Khasanov on 26/08/22.
//

import UIKit
import Combine

class DotPictureView: UIView {
    
    private let attachPin = UIImageView()
    private let container = UIView()
    private let dotsContainer = UIView()
    
    
    private let banner = UIView()
    private let nameTitle = UILabel()
    private let priceLabel = UILabel()
    private let bannerButton = UIButton()
    
    
    private let bannerWidth: CGFloat = 130
    private let bannerHeight: CGFloat = 70
    private let padding: CGFloat = 2
    
    private let dotBackgroundHeight: CGFloat = 20
    private let dotCircleHeight: CGFloat = 10
    private let attachPinHeight: CGFloat = 24
    
    private var totalWidth: CGFloat {
        max(dotBackgroundHeight, attachPinHeight)
    }
    
    private var totalHeight: CGFloat {
        (attachPinHeight * 2) + dotBackgroundHeight + (padding * 2)
    }
    
    private var productPin: [Int: UIView] = [:]
    
    var dots: [CoordinateModel] = [] {
        didSet {
            createDots()
        }
    }
    
    var product: ProductModel? {
        didSet {
            nameTitle.text = product?.getName()
            
            priceLabel.text = product?.total_price?.price
        }
    }
    
    let imageView = UIImageView()
    
    weak var productHelper: ProductHelper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
        setupBanner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        autolayout()
        configureViews()
        setupBanner()
    }
    
    func setupViews() {
        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(dotsContainer)
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dotsContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        var i = 0
        for dot in dots {
            let frame = getPinFrame(xPercentage: dot.x ?? 0, yPercentage: dot.y ?? 0)
            productPin[i]?.frame = frame
            
            i += 1
        }
    }
    
    ///x,y are percents x-100%
    private func createProductPin() {
        var i = 0
        productPin.removeAll()
        
        for _ in dots {
            productPin[i] = createDotView(id: i)
            i += 1
        }
    }
    
    private func createDotView(id: Int) -> UIView {
        let pinView = UIView()
        
        let backgroundCircle = getBackgroundCircle()
        
        let dotCircle = getDotCircle()
        
        let circleButton = getCircleButton(id: id)
        
        dotsContainer.addSubview(pinView)
        pinView.addSubview(backgroundCircle)
        backgroundCircle.addSubview(dotCircle)
        backgroundCircle.addSubview(circleButton)
        
        return pinView
    }
    
    private func getCircleButton(id: Int) -> UIButton {
        let button = UIButton(frame: .init(x: 0,
                                           y: 0,
                                           width: dotBackgroundHeight,
                                           height: dotBackgroundHeight))
        button.tag = id
        button.addTarget(self, action: #selector(dotClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func getBackgroundCircle() -> UIView {
        let view = UIView(frame: .init(x: max(0, (totalWidth - dotBackgroundHeight) / 2),
                                       y: max(0, (totalHeight - dotBackgroundHeight) / 2),
                                       width: dotBackgroundHeight,
                                       height: dotBackgroundHeight))
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = dotBackgroundHeight / 2
        
        return view
    }
    
    private func getDotCircle() -> UIView {
        let view = UIView(frame: .init(x: (dotBackgroundHeight - dotCircleHeight) / 2,
                                       y: (dotBackgroundHeight - dotCircleHeight) / 2,
                                       width: dotCircleHeight,
                                       height: dotCircleHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = dotCircleHeight / 2
        return view
    }
    
    private func getPinFrame(xPercentage: Int, yPercentage: Int) -> CGRect {
        .init(x: getX(xPercentage: xPercentage) - (totalWidth / 2),
              y: getY(yPercentage: yPercentage) - (totalHeight / 2),
              width: totalWidth,
              height: totalHeight)
    }
    
    private func getX(xPercentage: Int) -> CGFloat {
        self.frame.width * xPercentage.cgfloat / 100
    }
    
    private func getY(yPercentage: Int) -> CGFloat {
        self.frame.height * yPercentage.cgfloat / 100
    }
    
    private func checkIfHeightInside(id: Int) -> Bool {
        let minY = productPin[id]?.frame.minY ?? 0
        
        if minY - (bannerHeight + 10) > 0 {
            return true
        } else {
            return false
        }
    }
    
    private func getBannerFrame(id: Int, isTop: Bool) -> CGRect {
        
        guard let pinFrame = productPin[id]?.frame else { return .zero }
        
        var x: CGFloat
        var y: CGFloat
        
        
        if isTop {
            y = pinFrame.minY - bannerHeight + (attachPinHeight / 2) + padding
        } else {
            y = pinFrame.maxY - (attachPinHeight / 2) - padding
        }
    
        
        x = pinFrame.midX - (bannerWidth / 2)
        
        x = max(0, min(self.frame.width - bannerWidth, x))
        
        let frame = CGRect(x: x,
                           y: y,
                           width: bannerWidth,
                           height: bannerHeight)
        
        return frame
    }
    
    private func showBanner(frame: CGRect) {
        banner.isHidden = false
        banner.frame = frame
    }
    
    private func showPin(buttonFrame: CGRect, isTop: Bool) {
        attachPin.isHidden = false
        attachPin.frame = .init(x: buttonFrame.midX - (attachPinHeight / 2),
                                y: isTop ? (buttonFrame.minY - attachPinHeight - padding)
                                : buttonFrame.maxY + padding,
                                width: attachPinHeight,
                                height: attachPinHeight)
    }
    
    private func setupBanner() {
        setupBannerViews()
        autolayoutBannerViews()
        configureBannerViews()
    }
    
    private func setupBannerViews() {
        container.addSubview(attachPin)
        container.addSubview(banner)
        banner.addSubview(nameTitle)
        banner.addSubview(priceLabel)
        banner.addSubview(bannerButton)
    }
    
    private func autolayoutBannerViews() {
        banner.snp.makeConstraints { make in
            make.width.equalTo(bannerWidth)
            make.height.equalTo(bannerHeight)
        }
        
        attachPin.snp.makeConstraints { make in
            make.width.height.equalTo(attachPinHeight)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(8)
        }
        
        bannerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureBannerViews() {
        attachPin.image = .attach_pin
        attachPin.isHidden = true
        banner.layer.cornerRadius = 8
        banner.backgroundColor = .white
        banner.isHidden = true
        
        nameTitle.style(.regular, 12)
        nameTitle.textColor = .olchaTextBlack
        nameTitle.numberOfLines = 2
        nameTitle.textAlignment = .center
        
        priceLabel.style(.bold, 14)
        priceLabel.textColor = .olchaAccentColor
        priceLabel.textAlignment = .center
        
        bannerButton.addTarget(self, action: #selector(productSelected(_:)), for: .touchUpInside)
    }
    
    @objc private func dotClicked(_ sender: UIButton) {
        hideAllPins()
        let isTop = checkIfHeightInside(id: sender.tag)
        
        showBanner(frame: getBannerFrame(id: sender.tag, isTop: isTop))
        
        
        showPin(
            buttonFrame: sender.convert(sender.frame,
                                        to: dotsContainer),
            isTop: isTop
        )
        
        
        self.product = dots[sender.tag].product
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer) {
        hideAllPins()
    }
    
    @objc private func productSelected(_ sender: UIButton) {
        productHelper?.pushProduct.send(product)
    }
}

//MARK: - PUBLIC FUNCS
extension DotPictureView {
    
    public func hideAllPins() {
        banner.isHidden = true
        attachPin.isHidden = true
    }
    
    public func createDots() {
        hideAllPins()
        dotsContainer.subviews.forEach { $0.removeFromSuperview() }
        createProductPin()
        layoutSubviews()
        
    }
    
}
