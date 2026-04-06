//
//  BaseViewController+Delegate.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/10/22.
//

import UIKit
extension BaseViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tabbarAnimated {
            if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
                changeTabBar(hidden: true, animated: true)
            } else{
                changeTabBar(hidden: false, animated: true)
            }
        }
    }
    
    func changeTabBar(hidden: Bool, animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        if hidden {
            container.snp.remakeConstraints { make in
                make.top.equalTo(navigation.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(hasSafeArea ? 16 : 0)
            }
        }
        let offset = (hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (tabBar.frame.size.height) )
        if offset == tabBar.frame.origin.y { return }
        let duration: TimeInterval = (animated ? 0.25 : 0.0)
        
        UIView.animate(withDuration: duration,
                       animations: {
            tabBar.frame.origin.y = offset
        },
                       completion: { [weak self] _ in
            guard let self = self else { return }
            if !hidden {
                self.container.snp.remakeConstraints { make in
                    make.top.equalTo(self.navigation.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                }
            }
        })
    }

    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
