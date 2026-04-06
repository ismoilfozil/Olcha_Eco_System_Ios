//
//  IScrollView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 04/02/23.
//


import UIKit
public class IScrollView: UIView {
    public lazy var settings: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInset = .zero
        return scrollView
    }()
    
    public lazy var scrollContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
    }
    
    private func setupViews() {
        addSubview(settings)
        settings.addSubview(scrollContainer)
        scrollContainer.addSubview(container)
    }
    
    private func autolayout() {
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.top.bottom.equalToSuperview()
        }
    }
    
    public func addArrangedSubview(_ view: UIView?) {
        guard let view = view else { return }
        container.addArrangedSubview(view)
    }
    
    public func horizontalEdge( _ edge: CGFloat = 16) {
        container.snp.updateConstraints { make in
            make.left.right.equalToSuperview().inset(edge)
        }
    }
    
    public func addArrangedSubview(view: UIView?, horizontalEdge: CGFloat = 0) {
        guard let view else { return }
        container.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalEdge)
        }
    }
}
