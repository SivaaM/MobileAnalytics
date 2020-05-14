//
//  RowVM.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 13/05/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

protocol RowViewModel {}

protocol CellConfigurable {
    func setup(viewModel: RowViewModel)
}

class UserQuestionViewModel: RowViewModel {
    let question: String
    
    init(question: String) {
        self.question = question
    }
}

class BotResponseMembersViewModel: RowViewModel {
    let response: String
    let title: String
    let totalMbrs: Int
    
    init(response: String, title: String, totalMbrs: Int) {
        self.response = response
        self.title = title
        self.totalMbrs = totalMbrs
    }
}

class BotResponseChartViewModel: RowViewModel {
    let response: String
    let chartInfo: [Int]
    let parentVC: UIViewController
    
    init(response: String, chartInfo: [Int], parentVC: UIViewController) {
        self.response = response
        self.chartInfo = chartInfo
        self.parentVC = parentVC
    }
}
