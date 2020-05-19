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
    var formatedResponse: NSAttributedString {
        if let dateString  = response.slice(from: "(", to: ")") {
            let attribute = AttributedText(baseFont: UIFont(name: "TrebuchetMS", size: 20)!, baseColor: .white, attributedFont: UIFont(name: "TrebuchetMS", size: 17)!, attributedColor: .white, attributedText: dateString)
            return response.attributedStyle(for: attribute)
        } else {
            let attribute = AttributedText(baseFont: UIFont(name: "TrebuchetMS", size: 20)!, baseColor: .white, attributedFont: UIFont(name: "TrebuchetMS", size: 20)!, attributedColor: .white, attributedText: "")
            return response.attributedStyle(for: attribute)
        }
    }
    
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
    var formatedResponse: NSAttributedString {
        if let dateString  = response.slice(from: "(", to: ")") {
            let attribute = AttributedText(baseFont: UIFont(name: "TrebuchetMS", size: 20)!, baseColor: .white, attributedFont: UIFont(name: "TrebuchetMS", size: 17)!, attributedColor: .white, attributedText: dateString)
            return response.attributedStyle(for: attribute)
        } else {
            let attribute = AttributedText(baseFont: UIFont(name: "TrebuchetMS", size: 20)!, baseColor: .white, attributedFont: UIFont(name: "TrebuchetMS", size: 20)!, attributedColor: .white, attributedText: "")
            return response.attributedStyle(for: attribute)
        }
    }
    init(response: String, chartInfo: [Int], parentVC: UIViewController) {
        self.response = response
        self.chartInfo = chartInfo
        self.parentVC = parentVC
    }
}
