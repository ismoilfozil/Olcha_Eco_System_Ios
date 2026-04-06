//
//  LineChart.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/08/22.
//


import UIKit
import Combine
class OlchaChart: UIView, LineChartDelegate {

    private let container = UIView()
    
    private let lineChart = LineChart()
    
    private let trackerContainer = UIView()
    private let tracker = UIStackView()
    private let trackerTitle = UILabel()
    private let trackerPrice = UILabel()
    
    var data: [PriceHistory] = [] {
        didSet {
            lineChart.clearAll()
            lineChart.addLine(data.map { $0.price.cgfloat })
        }
    }
    
    private let trackSize = CGSize(width: 100, height: 50)
    
    private let dotRadius: CGFloat = 12
    
    private let innerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
        autolayout()
        configureViews()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
        container.addSubview(lineChart)
        container.addSubview(trackerContainer)
        trackerContainer.addSubview(tracker)
        tracker.addArrangedSubview(trackerTitle)
        tracker.addArrangedSubview(trackerPrice)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lineChart.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        trackerContainer.snp.makeConstraints { make in
            make.width.equalTo(trackSize.width)
            make.height.equalTo(trackSize.height)
        }
        
        tracker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
    }
    
    private func configureViews() {
        lineChart.animation.enabled = true
        lineChart.x.labels = .init(visible: false, values: [])
        lineChart.y.labels = .init(visible: false, values: [])
        
        lineChart.x.grid.visible = false
        lineChart.y.grid.visible = false
        lineChart.x.axis.visible = false
        lineChart.y.axis.visible = false
        
        lineChart.delegate = self
        
        lineChart.colors = [.olchaAccentColor]
        lineChart.dots.innerRadius = 8
        lineChart.dots.outerRadius = dotRadius
        lineChart.dots.color = .olchaAccentColor
        lineChart.clearsContextBeforeDrawing = true

        trackerContainer.backgroundColor = .white
        trackerContainer.border()
        trackerContainer.round(6)
        tracker.axis = .vertical
        tracker.spacing = 2
        
        trackerTitle.textColor = .olchaTextBlack
        trackerTitle.style(.regular, 12)
        trackerTitle.textAlignment = .center
        
        trackerPrice.textColor = .olchaTextBlack
        trackerPrice.style(.semibold, 12)
        trackerPrice.textAlignment = .center
        
        
    }
    
    
    
}
extension OlchaChart {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        
        guard lineChart.dotsPoints.count > x.int,
              data.count > x.int,
              x.int > -1
        else {
            return
        }
        
        let point = lineChart.convert(lineChart.dotsPoints[x.int], to: container)
        let maxX = container.frame.width - trackSize.width
        var newX = (point.x + (dotRadius / 2)) - (trackSize.width / 2)
        
        if maxX < newX {
            newX = maxX
        } else if newX < 0 {
            newX = 0
        }
        
        
        let newY = point.y - trackSize.height - 8
        
        trackerContainer.frame.origin = .init(x: newX, y: newY)
        
        trackerTitle.text = data[x.int].date
        trackerPrice.text = data[x.int].price.string.price
    }
    
    func didBeginTracking() {
//        tableScrollSwitcher?.send(false)
    }
    
    func didEndTracking() {
//        tableScrollSwitcher?.send(true)
    }
}
