//
//  BotResponseMembers.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 13/05/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

class BotResponseMembersCell: UITableViewCell, CellConfigurable {
    
    var reportConstraints: [NSLayoutConstraint]?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    var infoHeightAnchor: NSLayoutConstraint?

    var viewModel: BotResponseMembersViewModel?
    
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
    
    let responseLbl: UITextView = {
        let tv = UITextView()
        tv.text = "message"
        tv.font = UIFont(name: "TrebuchetMS", size: 20)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.white
        tv.textColor = .black
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    func setup(viewModel: RowViewModel) {
        if let vm = viewModel as? BotResponseMembersViewModel {
            self.viewModel = vm
            //question.text = vm.response
//            if let dateString  = vm.response.slice(from: "(", to: ")") {
//                let attribute = AttributedText(baseFont: UIFont(name: "TrebuchetMS", size: 20)!, baseColor: .white, attributedFont: UIFont(name: "TrebuchetMS", size: 17)!, attributedColor: .white, attributedText: dateString)
//                question.attributedText = vm.response.attributedStyle(for: attribute)
//            } else {
//                question.text = vm.response
//            }
            question.attributedText = vm.formatedResponse
            //question.textColor = .white
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
            
            performAddingResponseContainer(detail: detail)
        }
    }
    
    private func performAddingResponseContainer(detail: BotResponseMembersViewModel) {
        addSubview(responseLbl)
        let responseText = "\(detail.title) \(detail.totalMbrs)"
        let textHeight = responseText.estimateFrameForText().height + 30
        responseLbl.text = responseText
        responseLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        //goToReport.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        responseLbl.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 10).isActive = true
        responseLbl.heightAnchor.constraint(equalToConstant: textHeight).isActive = true
        responseLbl.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
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
