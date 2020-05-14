//
//  LineChartViewController.swift
//
//  Created by Fahath Rajak on 4/20/19.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: UIViewController, ChartViewDelegate {
    
    //var appChartInfo: AppChartInfo?
  lazy var lineChartView: LineChartView = {
    let lc = LineChartView()
    lc.backgroundColor = .white
    lc.translatesAutoresizingMaskIntoConstraints = false
      return lc
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(lineChartView)
    NSLayoutConstraint.activate(lineChartView.edgeConstraints(top: 0, left: 0, bottom: 0, right: 0))
  }
    
    func updateChart(_ appChartInfo: [Int]) {
        customizeChart(for: appChartInfo)
    }
  
    func customizeChart(for chartData: [Int], with title: String = "Member Info") {
        
    
    var dataEntries: [ChartDataEntry] = []
    
    for i in 0..<chartData.count {
        let graphValue: Double = Double(chartData[i])
        let dataEntry = ChartDataEntry(x: Double(i), y: graphValue)
        dataEntries.append(dataEntry)
    }
    
    let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: title)
        lineChartDataSet.colors = [.appDarkBlue]
        
    let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
    lineChartView.data = lineChartData
  }
}
