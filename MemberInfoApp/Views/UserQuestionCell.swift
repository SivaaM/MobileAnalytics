//
//  UserQuestion.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 13/05/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

class UserQuestionCell: UITableViewCell, CellConfigurable {
    
    let isChart: Bool = false
    var reportConstraints: [NSLayoutConstraint]?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    var infoHeightAnchor: NSLayoutConstraint?

    var viewModel: UserQuestionViewModel?
    
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
    
    func setup(viewModel: RowViewModel) {
        if let vm = viewModel as? UserQuestionViewModel {
            self.viewModel = vm
            question.text = vm.question
            question.textColor = .white
            question.textAlignment = .left
            bubbleView.backgroundColor = .appLightBlue
            performUpdateConstarints()
        }
    }
    
    private func performUpdateConstarints() {
        if let detail = viewModel {
            let textHeight = detail.question.estimateFrameForText().height + 30
            bubbleLeftAnchor?.isActive = true
            bubbleRightAnchor?.isActive = false
            bubbleHeightAnchor?.constant = textHeight
            bubbleWidthAnchor?.constant = detail.question.estimateFrameForText().width + 40
            infoHeightAnchor?.constant = textHeight
        }
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
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: 100)
        bubbleHeightAnchor?.isActive = true
        
        question.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        question.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        question.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        infoHeightAnchor = question.heightAnchor.constraint(equalToConstant: 0)
        infoHeightAnchor?.isActive = true

    }
    
}
