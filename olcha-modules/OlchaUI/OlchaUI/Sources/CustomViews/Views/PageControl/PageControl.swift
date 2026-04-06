//
//  PageControl.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 11/10/23.
//

import UIKit

public class PageControl: BaseView {
    
    private var maxPage = 3
    private var totalPage = 1
    private let settings: AdvancedPageControlView = {
        let pageControl = AdvancedPageControlView()
        pageControl.backgroundColor = .white
        pageControl.drawer = SlideDrawer(height: 6,
                                         width: 6,
                                         space: 2,
                                         raduis: 3,
                                         indicatorColor: .olchaAccentColor,
                                         dotsColor: .olchaAccentColor.withAlphaComponent(0.5))
        pageControl.round(5)
        return pageControl
    }()
    
    public override func setupViews() {
        addSubview(settings)
    }
    
    public override func autolayout() {
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(33)
        }
    }
    
    public func setup(totalPage: Int? = nil) {
        self.totalPage = totalPage ?? 1
        setup(pageNumbers: totalPage ?? 1)
    }
    
    public func setupProgress(with scrollView: UIScrollView) {
        if let page = Int.page(offset: scrollView.contentOffset, collection: scrollView) {
            setup(currentPage: page)
        }
    }
    
    public func setupSized(totalPage: Int? = nil) {
        self.totalPage = totalPage ?? 1
        guard self.totalPage > maxPage else { setup(totalPage: totalPage); return }
        setup(pageNumbers: min(maxPage, self.totalPage))
    }
    
    public func setupSizedProgress(with scrollView: UIScrollView) {
        if let page = Int.page(offset: scrollView.contentOffset, collection: scrollView) {
            guard totalPage > maxPage else { setupProgress(with: scrollView); return }
            if page == totalPage-1 {
                settings.setPage(maxPage-1)
            } else if page == 0 {
                settings.setPage(0)
            } else {
                settings.setPage(1)
            }
        }
    }
    
    private func setup(currentPage: Int) {
        settings.setPage(currentPage)
    }
    
    private func setup(pageNumbers: Int) {
        isHidden = !(pageNumbers > 1)
        settings.numberOfPages = pageNumbers
    }
}
