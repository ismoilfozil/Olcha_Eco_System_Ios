//
//  Composition.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 19/06/23.
//


import Combine
import UIKit
public typealias PageObserver = PassthroughSubject<CGPoint, Never>

public class Composition: UICollectionViewCompositionalLayout {
    
    public var section: NSCollectionLayoutSection?
    
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = layoutAttributesForItem(at: itemIndexPath)
        attr?.alpha = 1
        return attr
    }
    
    public override init(section: NSCollectionLayoutSection,
                         configuration: UICollectionViewCompositionalLayoutConfiguration = .init()
    ) {
        self.section = section
        super.init(section: section, configuration: configuration)
    }
    
    public override init(sectionProvider: @escaping UICollectionViewCompositionalLayoutSectionProvider, configuration: UICollectionViewCompositionalLayoutConfiguration) {
        super.init(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
