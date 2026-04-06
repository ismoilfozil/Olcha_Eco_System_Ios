//
//  SnapshotView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public class SnapshotView: UIImageView {
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        guard let image = image else { return }
        let isSmallHeight = image.size.height < 20 || image.size.width < 20
        let isMediumHeight = image.size.height < 40 || image.size.width < 40
        self.layer.cornerRadius = isSmallHeight ? 4 : isMediumHeight ? 8 : 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public extension UIView {
    func snapshot(horizontalEdge: CGFloat, verticalEdge: CGFloat) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: .init(width: bounds.size.width + (horizontalEdge*2),
                                                           height: bounds.size.height + (verticalEdge*2)))
        let image = renderer.image { ctx in
            self.drawHierarchy(in: .init(origin: .init(x: self.bounds.origin.x+horizontalEdge,
                                                       y: self.bounds.origin.y+verticalEdge),
                                         size: .init(width: self.bounds.size.width,
                                                     height: self.bounds.size.height)),
                               afterScreenUpdates: false)
        }
        return image
    }
    
    func addSnapshot(of view: UIView, horizontalEdge: CGFloat, verticalEdge: CGFloat) {
        guard let snapshot = view.snapshot(horizontalEdge: horizontalEdge,
                                           verticalEdge: verticalEdge) else { return }
        let imageView = SnapshotView(image: snapshot)
        let globalPoint = convert(view.frame.origin, from: view.superview)
        imageView.frame = CGRect(origin: .init(x: globalPoint.x-horizontalEdge,
                                               y: globalPoint.y-verticalEdge),
                                 size: .init(width: view.frame.size.width+(horizontalEdge*2),
                                             height: view.frame.size.height+(verticalEdge*2)))
        addSubview(imageView)
        imageView.fadeIn()
    }
    
    func removeSnapshots(withAnimation: Bool = true) {
        DispatchQueue.main.async {
            for subview in self.subviews where subview is SnapshotView {
                if withAnimation {
                    subview.fadeOut { subview.removeFromSuperview() }
                } else {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
