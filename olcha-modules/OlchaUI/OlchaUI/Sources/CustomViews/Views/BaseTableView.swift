//
//  BaseTableView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/08/22.
//

import UIKit
public typealias TableDelegates = UITableViewDelegate & UITableViewDataSource
public typealias CollectionDelegates = UICollectionViewDelegateFlowLayout & UICollectionViewDataSource


public enum BaseSection: Int {
    case models = 0
    case indicator = 1
}

open class BaseTableView: UITableView {
    public enum BaseSection {
        case models
        case indicator
    }
    
    public let baseSections: [BaseSection] = [
        .models,
        .indicator
    ]
    
    public enum LoadState {
        case loaded
        case notLoaded
        
        
        var value: Bool {
            switch self {
            case .loaded:
                return true
            case .notLoaded:
                return false
            }
        }
    }
    
    var tableHeights : [IndexPath: CGFloat] = [:]
    private var sectionStates : [Int: Bool] = [:]
    
    open func isLoaded(at index: Int) -> Bool {
        sectionStates[index] ?? false
    }
    
    open func changeState(at index: Int, state: LoadState) {
        sectionStates[index] = state.value
    }
    
    open func resetStates() {
        sectionStates = [:]
    }
    
    public func calculateTableViewHeight() -> CGFloat {
        var totalHeight: CGFloat = 0

        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let rowHeight = self.rectForRow(at: indexPath).height
                totalHeight += rowHeight
            }
        }

        return totalHeight
    }
}

public class BaseCollectionView: UICollectionView {

    public enum LoadState {
        case loaded
        case notLoaded
        case loading
    }
    
    public var collectionSizes : [IndexPath: CGSize] = [:]
    private var sectionStates : [Int: LoadState] = [:]
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let baseSections: [BaseSection] = [
        .models,
        .indicator
    ]
    
    
    open func isLoaded(at index: Int) -> Bool {
        sectionStates[index] == .loaded
    }
    
    open func changeState(at index: Int, state: LoadState) {
        sectionStates[index] = state
    }
    
    open func initialState() {
        sectionStates.forEach { key, _ in
            sectionStates[key] = .notLoaded
        }
    }
    
    open func resetStates() {
        sectionStates = [:]
    }
    
    public func configure() {
        registerClass(forCell: FooterCollectionItem.self)
        registerClass(forCell: HeaderItem.self)
    }
}
