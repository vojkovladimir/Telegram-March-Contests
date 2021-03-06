//
//  ChartLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/13/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

private let defaultLineWidth: CGFloat = 1

class ChartLayer: CALayer {
    override var frame: CGRect {
        didSet {
            updateLayers()
        }
    }
    
    public private(set) var chart: Chart = .empty
    public var range: Range<Int> = .zero
    
    public var lineWidth: CGFloat = defaultLineWidth {
        didSet {
            lineLayers.forEach {
                $1.lineWidth = lineWidth
            }
        }
    }
    
    var lineLayers: [Graph: GraphLayer] = [:]
    
    private func updateLayers(removeLines: Bool = false) {
        let maxValue = chart.maxValue(in: range)
        let maxRoundedValue = 10 * (CGFloat(maxValue) / 10.0).rounded(.up)
        
        let xLength = bounds.width / CGFloat(range.count - 1)
        let yLength = bounds.height / maxRoundedValue
        
        let size = CGSize(width: xLength, height: yLength)
        let origin = CGPoint(x: -CGFloat(range.startIndex) * size.width, y: 0)
        
        let graphBounds = CGRect(origin: origin, size: bounds.size)
        
        let lines = chart.lines.filter { $0.isEnabled }
        let removedLines = chart.lines.filter { !$0.isEnabled }
        
        if removeLines {
            removeAllSublayers()
        } else {
            for line in removedLines {
                lineLayers[line]?.removeFromSuperlayer()
            }
        }
        
        var lineLayer: GraphLayer!
        
        for line in lines {
            lineLayer = lineLayers[line] ?? GraphLayer()
            lineLayer.lineWidth = lineWidth
            lineLayer.update(line, size: size, in: graphBounds)
            
            lineLayers[line] = lineLayer
            
            if lineLayer.superlayer == nil {
                addSublayer(lineLayer)
            }
        }
        
    }
    
    public func setChart(_ chart: Chart) {
        setChart(chart, range: chart.x.range)
    }
    
    public func setChart(_ chart: Chart, range: Range<Int>) {
        let chartChanged = self.chart != chart
        self.chart = chart
        self.range = range
      
        updateLayers(removeLines: chartChanged)
    }
    
    public func update() {
        updateLayers(removeLines: false)
    }
}
