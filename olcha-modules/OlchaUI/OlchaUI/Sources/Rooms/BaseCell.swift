//
//  BaseTableCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import Combine
import SkeletonView
 
extension IndexPath {
    public var isFirst: Bool {
        self.item == 0
    }
}
public protocol ChoosableCell {
    var isChosen: Bool { get set }
    var enabled: Bool { get set }
}

public enum RoundStyle {
    case top
    case middle
    case bottom
    case single
}

open class BaseCollectionCell: UICollectionViewCell {
    public enum Position {
        case top
        case bottom
        case left
        case right
    }
    
    public lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private let bottomSeparator: Divide = {
        let view = Divide()
        view.height = 0.5
        view.isHidden = true
        return view
    }()
    
    private let topSeparator: Divide = {
        let view = Divide()
        view.height = 0.5
        view.isHidden = true
        return view
    }()
    
    private let leftSeparator: HorizontalDivide = {
        let view = HorizontalDivide()
        view.width = 0.5
        view.isHidden = true
        return view
    }()
    
    private let rightSeparator: HorizontalDivide = {
        let view = HorizontalDivide()
        view.width = 0.5
        view.isHidden = true
        return view
    }()
    
    public let indicator = OlchaIndicator()
    
    private lazy var separators: [UIView] = [
        topSeparator,
        bottomSeparator,
        leftSeparator,
        rightSeparator
    ]
    
    public var horizontalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public var verticalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(container)
        container.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        setupViews()
        autolayout()
        configureViews()
    }
    open func setupViews() {}
    open func configureViews() {}
    open func autolayout() {}
    
    open var skeletonViews: [UIView] = []
    public func configure(skeleton: Skeleton?) {
        let isAnimated = skeleton?.isAnimating ?? false
        
        skeletonViews.forEach {
            if isAnimated {
                $0.showAnimatedGradientSkeleton()
            } else {
                $0.hideSkeleton()
            }
        }
        if !isAnimated {
            skeletonFinished()
        }
    }
   
    
    public func makeSkeleton(views: [UIView]) {
        skeletonViews = views
        skeletonViews.forEach { $0.isSkeletonable = true }
    }
    
    open func skeletonFinished() {
        
    }
    
    open func cellWillAppear() {}
    
    public func topCorner(_ corner: CGFloat = 12) {
        container.round(corner, topCorner: true, bottomCorner: false)
    }
    
    public func bottomCorner(_ corner: CGFloat = 12) {
        container.round(corner, topCorner: false, bottomCorner: true)
    }
    
    public func corner(_ corner: CGFloat) {
        container.round(corner, topCorner: true, bottomCorner: true)
    }
    
    private func updateLayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalEdge)
            make.top.bottom.equalToSuperview().inset(verticalEdge)
        }
    }
    
    public func enableSeparators(for view: UIView) {
        view.addSubview(topSeparator)
        view.addSubview(bottomSeparator)
        view.addSubview(leftSeparator)
        view.addSubview(rightSeparator)
        separatorLayout()
    }
    
    private func separatorLayout() {
        topSeparator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        leftSeparator.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        rightSeparator.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
    }
    
    public func separatorState(positions: [Position]) {
        separators.forEach { $0.isHidden = true }
        for position in positions {
            switch position {
            case .top:
                topSeparator.isHidden = false
            case .bottom:
                bottomSeparator.isHidden = false
            case .left:
                leftSeparator.isHidden = false
            case .right:
                rightSeparator.isHidden = false
            }
        }
    }
    
    
    public func showIndicator() {
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    public func hideIndicator() {
        indicator.removeFromSuperview()
    }
    
    public func observeIndicator(state: Bool) {
        state ? showIndicator() : hideIndicator()
    }
    
}

open class BaseTableCell: UITableViewCell {

    public let indicator = OlchaIndicator()
    
    public lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    public var horizontalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public var verticalEdge: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        baseSetup()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        self.clipsToBounds = true
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(container)
        container.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        setupViews()
        autolayout()
        configureViews()
    }
    
    open func setupViews() {}
    open func configureViews() {}
    open func autolayout() {}
    
    public func showIndicator() {
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    public func hideIndicator() {
        indicator.removeFromSuperview()
    }
    
    public func observeIndicator(state: Bool) {
        state ? showIndicator() : hideIndicator()
    }
    
    
    open var skeletonViews: [UIView] = []
    public func configure(skeleton: Skeleton?) {
        let isAnimated = skeleton?.isAnimating ?? false
        
        skeletonViews.forEach {
            if isAnimated {
                $0.showAnimatedGradientSkeleton()
            } else {
                $0.hideSkeleton()
            }
        }
        if !isAnimated {
            skeletonFinished()
        }
    }
    
    public func makeSkeleton(views: [UIView]) {
        skeletonViews = views
        skeletonViews.forEach { $0.isSkeletonable = true }
    }
    
    public func addSkeleton(view: UIView) {
        skeletonViews.append(view)
        view.isSkeletonable = true
    }
    
    open func skeletonFinished() {
        
    }
    
    public func topCorner(_ corner: CGFloat = 12) {
        container.round(corner, topCorner: true, bottomCorner: false)
    }
    
    public func bottomCorner(_ corner: CGFloat = 12) {
        container.round(corner, topCorner: false, bottomCorner: true)
    }
    
    public func corner(_ corner: CGFloat) {
        container.round(corner, topCorner: true, bottomCorner: true)
    }
    
    private func updateLayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalEdge)
            make.top.bottom.equalToSuperview().inset(verticalEdge)
        }
    }
    
    public func makeRoundStyle(_ style: RoundStyle, _ size: CGFloat = 12) {
        switch style {
        case .top:
            topCorner(size)
        case .middle:
            corner(0)
        case .bottom:
            bottomCorner(size)
        case .single:
            corner(0)
        }
    }
}

