//
//  ChartCell.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/23/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit
import QuartzCore

import Chart

protocol ChartCellDelegate: class {
    func chartCell(_ cell: ChartCell, rangeDidChanged range: Range<Int>)
}

class ChartCell: UITableViewCell {
    
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var chartSlider: ChartRangeSlider!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    weak var delegate: ChartCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        separatorInset = UIEdgeInsets(top: 0, left: frame.width, bottom: 0, right: 0)
    }
    
    func show(_ chart: Chart) {
        chartView.update(chart: chart, range: chart.range, animated: false)
        
        chartSlider.chart = chart
        chartSlider.range = chart.range
        
        updateVisibility(animated: true)
    }
    
    func update(animated: Bool = true) {
        chartView.update(animated: animated)
        chartSlider.update()
        
        updateVisibility(animated: animated)
    }
    
    private func updateVisibility(animated: Bool = true) {
        let isEmpty = chartSlider.chart.lines.filter({ $0.isEnabled }).isEmpty
        
        let alpha: CGFloat = isEmpty ? 0 : 1
        
        if (animated) {
            UIView.animate(withDuration: 0.3) {
                self.chartView.alpha = alpha
                self.chartSlider.alpha = alpha
                
                self.noDataLabel.alpha = isEmpty ? 1.0 : 0.0
            }
        }
    }

    @IBAction func rangeDidChanged(_ sender: ChartRangeSlider, forEvent event: UIEvent) {
        chartView.update(range: sender.range)
        
        delegate?.chartCell(self, rangeDidChanged: sender.range)
    }
}
