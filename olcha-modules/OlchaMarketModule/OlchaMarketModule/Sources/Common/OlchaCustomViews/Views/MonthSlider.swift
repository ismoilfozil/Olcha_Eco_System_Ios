//
//  MonthSlider.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import UIKit
import OlchaUI

// MARK: - Self-sizing collection view

private final class SelfSizingCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize { contentSize }
}

// MARK: - Month button cell

private final class MonthCell: UICollectionViewCell {
    static let id = "MonthCell"
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.masksToBounds = true
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }

    func configure(month: Int, isSelected: Bool) {
        label.text = isSelected ? "\(month) " + "month_short".localized() : "\(month)"
        label.style(.medium, 14)
        label.textColor = isSelected ? .white : .olchaTextBlack
        contentView.backgroundColor = isSelected
            ? .olchaAccentColor
            : (UIColor.olchaLightNeutralGray?.withAlphaComponent(0.35) ?? UIColor(white: 0.92, alpha: 1))
    }
}

// MARK: - MonthSlider

class MonthSlider: UIView {

    private var cv: SelfSizingCollectionView!
    private var months: [Int] = Array(3...12)
    private var selectedMonth: Int = 3

    weak var delegate: SliderViewDelegate?

    var forcedStep: Int = 3 {
        didSet {
            selectedMonth = forcedStep
            cv?.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildCollectionView()
    }

    func setup(min: Int, max: Int, delegate: SliderViewDelegate) {
        months = Array(min...max)
        selectedMonth = min
        self.delegate = delegate
        cv.reloadData()
        invalidateIntrinsicContentSize()
    }

    func setup(periods: [Int], delegate: SliderViewDelegate) {
        months = periods.sorted()
        selectedMonth = months.first ?? 0
        self.delegate = delegate
        cv.reloadData()
        invalidateIntrinsicContentSize()
    }

    private func selectedItemWidth(month: Int) -> CGFloat {
        let text = "\(month) " + "month_short".localized()
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let textWidth = (text as NSString).size(withAttributes: [.font: font]).width
        return max(40, ceil(textWidth) + 24)
    }

    private func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        cv = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.id)
        cv.dataSource = self
        cv.delegate = self

        addSubview(cv)
        cv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionView

extension MonthSlider: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        months.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.id, for: indexPath) as? MonthCell else {
            return UICollectionViewCell()
        }
        let month = months[indexPath.item]
        cell.configure(month: month, isSelected: month == selectedMonth)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let month = months[indexPath.item]
        let width = month == selectedMonth ? selectedItemWidth(month: month) : 40
        return CGSize(width: width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let month = months[indexPath.item]
        selectedMonth = month
        collectionView.reloadData()
        delegate?.valueChanged(month: month)
    }
}
