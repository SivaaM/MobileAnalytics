//
//  BotResponseChart.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 13/05/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

class BotResponseChartCell: UITableViewCell, CellConfigurable {
    
    var reportConstraints: [NSLayoutConstraint]?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    var infoHeightAnchor: NSLayoutConstraint?

    var viewModel: BotResponseChartViewModel?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .appDarkBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let question: UITextView = {
        let tv = UITextView()
        tv.text = "message"
        tv.font = UIFont(name: "TrebuchetMS", size: 20)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let chartContainer: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var chartVC: LineChartViewController = {
        return LineChartViewController.init()
    }()
    
    func setup(viewModel: RowViewModel) {
        if let vm = viewModel as? BotResponseChartViewModel {
            self.viewModel = vm
//            question.text = vm.response
//            question.textColor = .white
            question.attributedText = vm.formatedResponse

            question.textAlignment = .left
            bubbleView.backgroundColor = .appDarkBlue
            performUpdateConstarints()
        }
    }
    
    func performUpdateConstarints() {
        if let detail = viewModel {
            let textHeight = detail.response.estimateFrameForText().height + 30
            bubbleLeftAnchor?.isActive = false
            bubbleRightAnchor?.isActive = true
            bubbleHeightAnchor?.constant = textHeight
            bubbleWidthAnchor?.constant = detail.response.estimateFrameForText().width + 40
            infoHeightAnchor?.constant = textHeight
            
            performAddingChartContainer(detail: detail)
        }
    }
    
    private func performAddingChartContainer(detail: BotResponseChartViewModel) {
        chartVC.updateChart(detail.chartInfo)
        addSubview(chartContainer)
        chartContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        //goToReport.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        chartContainer.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 10).isActive = true
        chartContainer.heightAnchor.constraint(equalToConstant: 350).isActive = true
        chartContainer.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        addChildVC(detail.parentVC)
    }
    
    private func addChildVC(_ parentVC: UIViewController) {
        chartVC.view.frame = chartContainer.bounds
        parentVC.addChild(chartVC)
        chartVC.didMove(toParent: parentVC)
        chartContainer.addSubview(chartVC.view)
    }
    
    private func removeChildVC() {
        chartVC.view.removeFromSuperview()
        chartVC.removeFromParent()
        chartVC.willMove(toParent: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialView()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialView()
        setUpConstraints()
    }

    func setupInitialView() {
        self.selectionStyle = .none
    }
    
    func setUpConstraints() {
        backgroundColor = .appLightGray
        
        addSubview(bubbleView)
        addSubview(question)
        //x,y,w,h
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        //bubbleRightAnchor?.isActive = false
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        //bubbleLeftAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        //bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: 100)
        bubbleHeightAnchor?.isActive = true
        
        question.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        question.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        question.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        
        infoHeightAnchor = question.heightAnchor.constraint(equalToConstant: 0)
        infoHeightAnchor?.isActive = true
        
    }
    
}
