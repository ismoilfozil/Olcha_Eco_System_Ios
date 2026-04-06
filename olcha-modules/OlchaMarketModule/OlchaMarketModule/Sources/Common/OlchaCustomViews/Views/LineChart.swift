//
//  LineChart.swift
//  ChartView
//
//  Created by Elbek Khasanov on 08/08/22.
//

import Foundation

import UIKit
import QuartzCore

// delegate method
public protocol LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat])
}

/**
 * LineChart
 */
open class LineChart: UIView {
    
    /**
    * Helpers class
    */
    fileprivate class Helpers {
        
        /**
        * Convert hex color to UIColor
        */
        fileprivate class func UIColorFromHex(_ hex: Int) -> UIColor {
            let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((hex & 0xFF)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        /**
        * Lighten color.
        */
        fileprivate class func lightenUIColor(_ color: UIColor) -> UIColor {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
        }
    }
    
    public struct Labels {
        public var visible: Bool = true
        public var values: [String] = []
    }
    
    public struct Grid {
        public var visible: Bool = true
        public var count: CGFloat = 10
        // #eeeeee
        public var color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    }
    
    public struct Axis {
        public var visible: Bool = true
        // #607d8b
        public var color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
        public var inset: CGFloat = 0
    }
    
    public struct Coordinate {
        // public
        public var labels: Labels = Labels()
        public var grid: Grid = Grid()
        public var axis: Axis = Axis()
        
        // private
        fileprivate var linear: LinearScale?
        fileprivate var scale: ((CGFloat) -> CGFloat)?
        fileprivate var invert: ((CGFloat) -> CGFloat)?
        fileprivate var ticks: (CGFloat, CGFloat, CGFloat)?
    }
    
    public struct Animation {
        public var enabled: Bool = true
        public var duration: CFTimeInterval = 1
    }
    
    public struct Dots {
        public var visible: Bool = true
        public var color: UIColor = UIColor.white
        public var innerRadius: CGFloat = 8
        public var outerRadius: CGFloat = 12
        public var innerRadiusHighlighted: CGFloat = 8
        public var outerRadiusHighlighted: CGFloat = 12
    }
    
    // default configuration
    open var area: Bool = true
    open var animation: Animation = Animation()
    open var dots: Dots = Dots()
    open var lineWidth: CGFloat = 2
    
    open var x: Coordinate = Coordinate()
    open var y: Coordinate = Coordinate()

    
    // values calculated on init
    fileprivate var drawingHeight: CGFloat = 0 {
        didSet {
            let max = getMaximumValue()
            let min = getMinimumValue()
            y.linear = LinearScale(domain: [min, max], range: [0, drawingHeight])
            y.scale = y.linear?.scale()
            y.ticks = y.linear?.ticks(Int(y.grid.count))
        }
    }
    fileprivate var drawingWidth: CGFloat = 0 {
        didSet {
            let data = dataStore[0]
            x.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
            x.scale = x.linear?.scale()
            x.invert = x.linear?.invert()
            x.ticks = x.linear?.ticks(Int(x.grid.count))
        }
    }
    
    open var delegate: LineChartDelegate?
    
    // data stores
    fileprivate var dataStore: [[CGFloat]] = []
    fileprivate var dotsDataStore: [[DotCALayer]] = []
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    var dotsPoints: [CGPoint] = [] {
        didSet {
            delegate?.didSelectDataPoint(0, yValues: [])
        }
    }
    
    fileprivate var removeAll: Bool = false
    
    // category10 colors from d3 - https://github.com/mbostock/d3/wiki/Ordinal-Scales
    open var colors: [UIColor] = [
        UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1),
        UIColor(red: 1, green: 0.498039, blue: 0.054902, alpha: 1),
        UIColor(red: 0.172549, green: 0.627451, blue: 0.172549, alpha: 1),
        UIColor(red: 0.839216, green: 0.152941, blue: 0.156863, alpha: 1),
        UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1),
        UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1),
        UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1),
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 0.0901961, green: 0.745098, blue: 0.811765, alpha: 1)
    ]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        
        if removeAll {
            let context = UIGraphicsGetCurrentContext()
            context?.clear(rect)
            return
        }
        
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
        
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        // remove all dots on device rotation
        for dotsData in dotsDataStore {
            for dot in dotsData {
                dot.removeFromSuperlayer()
            }
        }
        dotsDataStore.removeAll()
        
        // draw grid
        if x.grid.visible && y.grid.visible { drawGrid() }
        
        // draw axes
        if x.axis.visible && y.axis.visible { drawAxes() }
        
        // draw labels
        if x.labels.visible { drawXLabels() }
        if y.labels.visible { drawYLabels() }
        
        // draw lines
        for (lineIndex, _) in dataStore.enumerated() {
            
            drawLine(lineIndex)
            
            // draw dots
            if dots.visible { drawDataDots(lineIndex) }
            
            // draw area under line chart
            if area { drawAreaBeneathLineChart(lineIndex) }
            
        }
        
    }
    
    
    
    /**
     * Get y value for given x value. Or return zero or maximum value.
     */
    fileprivate func getYValuesForXValue(_ x: Int) -> [CGFloat] {
        var result: [CGFloat] = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    
    
    /**
     * Handle touch events.
     */
    fileprivate func handleTouchEvents(_ touches: NSSet, event: UIEvent) {
        if (self.dataStore.isEmpty) {
            return
        }
        guard let point: AnyObject = touches.anyObject() as? AnyObject else { return }
        let xValue = point.location(in: self).x
        let val = xValue - x.axis.inset
        if let inverted = self.x.invert {
            let inverted = inverted(val)
            let rounded = Int((Double(inverted).rounded(.toNearestOrAwayFromZero)))
            let yValues: [CGFloat] = getYValuesForXValue(rounded)
            highlightDataPoints(rounded)
            delegate?.didSelectDataPoint(CGFloat(rounded), yValues: yValues)
        }
    }
    
    
    
    /**
     * Listen on touch end event.
     */
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touches = touches as? NSSet, let event = event {
            handleTouchEvents(touches, event: event)
        }
    }
    
    
    
    /**
     * Listen on touch move event
     */
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touches = touches as? NSSet, let event = event {
            handleTouchEvents(touches, event: event)
        }
    }
    
    
    
    /**
     * Highlight data points at index.
     */
    fileprivate func highlightDataPoints(_ index: Int) {
        for (lineIndex, dotsData) in dotsDataStore.enumerated() {
            // make all dots white again
            for dot in dotsData {
                dot.backgroundColor = UIColor.olchaAccentColor.cgColor
                dot.transform = CATransform3DMakeScale(1, 1, 1)
            }
            // highlight current data point
            var dot: DotCALayer
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index]
            }
            dot.backgroundColor = UIColor.olchaAccentColor.cgColor
            dot.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        }
    }
    
    
    
    /**
     * Draw small dot at every data point.
     */
    fileprivate func drawDataDots(_ lineIndex: Int) {
        var dotLayers: [DotCALayer] = []
        var data = self.dataStore[lineIndex]
        
        for index in 0..<data.count {
            if let xScale = self.x.scale, let yScale = self.y.scale {
                let xValue = xScale(CGFloat(index)) + x.axis.inset - dots.outerRadius/2
                let yValue = self.bounds.height - yScale(data[index]) - y.axis.inset - dots.outerRadius/2
                
                // draw custom layer with another layer in the center
                let dotLayer = DotCALayer()
                dotLayer.dotInnerColor = .white
                dotLayer.innerRadius = dots.innerRadius
                dotLayer.backgroundColor = dots.color.cgColor
                dotLayer.cornerRadius = dots.outerRadius / 2
                dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
                self.layer.addSublayer(dotLayer)
                dotLayers.append(dotLayer)
                
                // animate opacity
                if animation.enabled {
                    let anim = CABasicAnimation(keyPath: "opacity")
                    anim.duration = animation.duration
                    anim.fromValue = 0
                    anim.toValue = 1
                    dotLayer.add(anim, forKey: "opacity")
                }
                self.dotsPoints.append(.init(x: xValue, y: yValue))
            }
        }
        dotsDataStore.append(dotLayers)
    }
    
    
    
    /**
     * Draw x and y axis.
     */
    fileprivate func drawAxes() {
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()
        // draw x-axis
        x.axis.color.setStroke()
        guard let yScale = self.y.scale else { return }
        let y0 = height - yScale(0) - y.axis.inset
        path.move(to: CGPoint(x: x.axis.inset, y: y0))
        path.addLine(to: CGPoint(x: width - x.axis.inset, y: y0))
        path.stroke()
        // draw y-axis
        y.axis.color.setStroke()
        path.move(to: CGPoint(x: x.axis.inset, y: height - y.axis.inset))
        path.addLine(to: CGPoint(x: x.axis.inset, y: y.axis.inset))
        path.stroke()
    }
    
    
    
    /**
     * Get maximum value in all arrays in data store.
     */
    fileprivate func getMaximumValue() -> CGFloat {
        var max: CGFloat = 1
        for data in dataStore {
            if let newMax = data.max() {
                if newMax > max {
                    max = newMax
                }
            }
        }
        return max
    }
    
    
    
    /**
     * Get maximum value in all arrays in data store.
     */
    fileprivate func getMinimumValue() -> CGFloat {
        var min: CGFloat = 0
        for data in dataStore {
            if let newMin = data.min() {
                if newMin < min {
                    min = newMin
                }
            }
        }
        return min
    }
    
    
    
    /**
     * Draw line.
     */
    fileprivate func drawLine(_ lineIndex: Int) {
        guard let xscale = self.x.scale, let yscale = self.y.scale else { return }
        var data = self.dataStore[lineIndex]
        guard !data.isEmpty else { return }
        let path = UIBezierPath()
        
        var xValue = xscale(0) + x.axis.inset
        var yValue = self.bounds.height - yscale(data[0]) - y.axis.inset
        path.move(to: CGPoint(x: xValue, y: yValue))
        for index in 1..<data.count {
            xValue = xscale(CGFloat(index)) + x.axis.inset
            yValue = self.bounds.height - yscale(data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: xValue, y: yValue))
        }
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.cgPath
        layer.strokeColor = colors[lineIndex].cgColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        self.layer.addSublayer(layer)
        
        // animate line drawing
        if animation.enabled {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = animation.duration
            anim.fromValue = 0
            anim.toValue = 1
            layer.add(anim, forKey: "strokeEnd")
        }
        
        // add line layer to store
        lineLayerStore.append(layer)
    }
    
    
    
    /**
     * Fill area between line chart and x-axis.
     */
    fileprivate func drawAreaBeneathLineChart(_ lineIndex: Int) {
        
        let data = self.dataStore[lineIndex]
        guard !data.isEmpty else { return }
        let path = UIBezierPath()
        
        UIColor.clear.setFill()
        guard let xscale = self.x.scale, let yscale = self.y.scale else { return }
        path.move(to: CGPoint(x: x.axis.inset, y: self.bounds.height - yscale(0) - y.axis.inset))
        
        path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - yscale(data[0]) - y.axis.inset))
        
        for index in 1..<data.count {
            let x1 = xscale(CGFloat(index)) + x.axis.inset
            let y1 = self.bounds.height - yscale(data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: x1, y: y1))
        }
        
        path.addLine(to: CGPoint(x: xscale(CGFloat(data.count - 1)) + x.axis.inset, y: self.bounds.height - yscale(0) - y.axis.inset))
        
        path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - yscale(0) - y.axis.inset))
        path.fill()
        
        
        
        let gradient = CAGradientLayer()
        gradient.frame = path.bounds
        gradient.colors = [UIColor.olchaAccentColor.withAlphaComponent(0.2).cgColor, UIColor.olchaAccentColor.withAlphaComponent(0.01).cgColor]
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        
        gradient.mask = shapeMask
        layer.insertSublayer(gradient, at: 0)
    }
    
    
    
    /**
     * Draw x grid.
     */
    fileprivate func drawXGrid() {
        guard let xscale = self.x.scale else { return }
        x.grid.color.setStroke()
        let path = UIBezierPath()
        var x1: CGFloat
        let y1: CGFloat = self.bounds.height - y.axis.inset
        let y2: CGFloat = y.axis.inset
        guard let ticks = self.x.ticks else { return }
        let (start, stop, step) = ticks
        for i in stride(from: start, through: stop, by: step){
            x1 = xscale(i) + x.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x1, y: y2))
        }
        path.stroke()
    }
    
    
    
    /**
     * Draw y grid.
     */
    fileprivate func drawYGrid() {
        guard let tricks = self.y.ticks, let yscale = self.y.scale else { return }
        self.y.grid.color.setStroke()
        let path = UIBezierPath()
        let x1: CGFloat = x.axis.inset
        let x2: CGFloat = self.bounds.width - x.axis.inset
        var y1: CGFloat
        let (start, stop, step) = tricks
        for i in stride(from: start, through: stop, by: step){
            y1 = self.bounds.height - yscale(i) - y.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y1))
        }
        path.stroke()
    }
    
    
    
    /**
     * Draw grid.
     */
    fileprivate func drawGrid() {
        drawXGrid()
        drawYGrid()
    }
    
    
    
    /**
     * Draw x labels.
     */
    fileprivate func drawXLabels() {
        guard let xscale = self.x.scale, let linear = x.linear else { return }
        let xAxisData = self.dataStore[0]
        let y = self.bounds.height - x.axis.inset
        let (_, _, step) = linear.ticks(xAxisData.count)
        let width = xscale(step)
        
        var text: String
        for (index, _) in xAxisData.enumerated() {
            let xValue = xscale(CGFloat(index)) + x.axis.inset - (width / 2)
            let label = UILabel(frame: CGRect(x: xValue, y: y, width: width, height: x.axis.inset))
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.textAlignment = .center
            if (x.labels.values.count != 0) {
                text = x.labels.values[index]
            } else {
                text = String(index)
            }
            label.text = text
            self.addSubview(label)
        }
    }
    
    
    
    /**
     * Draw y labels.
     */
    fileprivate func drawYLabels() {
        var yValue: CGFloat
        guard let ticks = self.x.ticks, let yscale = self.y.scale else { return }
        let (start, stop, step) = ticks
        for i in stride(from: start, through: stop, by: step){
            yValue = self.bounds.height - yscale(i) - (y.axis.inset * 1.5)
            let label = UILabel(frame: CGRect(x: 0, y: yValue, width: y.axis.inset, height: y.axis.inset))
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.textAlignment = .center
            label.text = String(Int((i).rounded(.toNearestOrAwayFromZero)))
            self.addSubview(label)
        }
    }
    
    
    
    /**
     * Add line chart
     */
    open func addLine(_ data: [CGFloat]) {
        self.dataStore.append(data)
        self.setNeedsDisplay()
    }
    
    
    
    /**
     * Make whole thing white again.
     */
    open func clearAll() {
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    
    
    /**
     * Remove charts, areas and labels but keep axis and grid.
     */
    open func clear() {
        // clear data
        dataStore.removeAll()
        self.setNeedsDisplay()
    }
}



/**
 * DotCALayer
 */
class DotCALayer: CALayer {
    
    var innerRadius: CGFloat = 8
    var dotInnerColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let inset = self.bounds.size.width - innerRadius
        let innerDotLayer = CALayer()
        innerDotLayer.frame = self.bounds.insetBy(dx: inset/2, dy: inset/2)
        innerDotLayer.backgroundColor = dotInnerColor.cgColor
        innerDotLayer.cornerRadius = innerRadius / 2
        self.addSublayer(innerDotLayer)
    }
    
}



/**
 * LinearScale
 */
open class LinearScale {
    
    var domain: [CGFloat]
    var range: [CGFloat]
    
    public init(domain: [CGFloat] = [0, 1], range: [CGFloat] = [0, 1]) {
        self.domain = domain
        self.range = range
    }
    
    open func scale() -> (_ x: CGFloat) -> CGFloat {
        return bilinear(domain, range: range, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    open func invert() -> (_ x: CGFloat) -> CGFloat {
        return bilinear(range, range: domain, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    open func ticks(_ m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTicks(domain, m: m)
    }
    
    fileprivate func scale_linearTicks(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTickRange(domain, m: m)
    }
    
    fileprivate func scale_linearTickRange(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        var extent = scaleExtent(domain)
        let span = extent[1] - extent[0]
        var step = CGFloat(pow(10, floor(log(Double(span) / Double(m)) / M_LN10)))
        let err = CGFloat(m) / span * step
        
        // Filter ticks to get closer to the desired count.
        if (err <= 0.15) {
            step *= 10
        } else if (err <= 0.35) {
            step *= 5
        } else if (err <= 0.75) {
            step *= 2
        }
        
        // Round start and stop values to step interval.
        let start = ceil(extent[0] / step) * step
        let stop = floor(extent[1] / step) * step + step * 0.5 // inclusive
        
        return (start, stop, step)
    }
    
    fileprivate func scaleExtent(_ domain: [CGFloat]) -> [CGFloat] {
        let start = domain[0]
        let stop = domain[domain.count - 1]
        return start < stop ? [start, stop] : [stop, start]
    }
    
    fileprivate func interpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        var diff = b - a
        func f(_ c: CGFloat) -> CGFloat {
            return (a + diff) * c
        }
        return f
    }
    
    fileprivate func uninterpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        var diff = b - a
        var re = diff != 0 ? 1 / diff : 0
        func f(_ c: CGFloat) -> CGFloat {
            return (c - a) * re
        }
        return f
    }
    
    fileprivate func bilinear(_ domain: [CGFloat], range: [CGFloat], uninterpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat, interpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat) -> (_ c: CGFloat) -> CGFloat {
        var u: (_ c: CGFloat) -> CGFloat = uninterpolate(domain[0], domain[1])
        var i: (_ c: CGFloat) -> CGFloat = interpolate(range[0], range[1])
        func f(_ d: CGFloat) -> CGFloat {
            return i(u(d))
        }
        return f
    }
    
}
