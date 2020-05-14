//
//  DetailVC.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 3/25/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

class ChatFlowVC: UITableViewController {
    
    lazy var chatVM: ChatViewModel = {
        return ChatViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startBinding()
    }
    
    func setupView() {
        tableView.backgroundColor = .appLightGray
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        tableView.register(UserQuestionCell.self, forCellReuseIdentifier: UserQuestionCell.cellIdentifier())
        tableView.register(BotResponseMembersCell.self, forCellReuseIdentifier: BotResponseMembersCell.cellIdentifier())
        tableView.register(BotResponseChartCell.self, forCellReuseIdentifier: BotResponseChartCell.cellIdentifier())


        tableView.reloadData()
    }
    
    func startBinding() {
        chatVM.rowViewModel.addObserver { [weak self](_) in
            self?.tableView.reloadData()
            if let rowCount = self?.chatVM.rowViewModel.value.count, rowCount > 0 {
                self?.tableView.scrollToRow(at: IndexPath(row: rowCount - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
}

extension ChatFlowVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chatVM.rowViewModel.value.count == 0 {
            self.tableView.setEmptyMessage("Hi, How Can I Help You?")
        } else {
            self.tableView.restore()
        }
        return chatVM.rowViewModel.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowViewModel = chatVM.rowViewModel.value[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: chatVM.cellIdentifier(for: rowViewModel), for: indexPath)

        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }
        return cell

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowViewModel = chatVM.rowViewModel.value[indexPath.row]
        var defHeight: CGFloat = 0

        if let vm = rowViewModel as? UserQuestionViewModel {
            
            defHeight = vm.question.estimateFrameForText().height + 40
        } else if let vm = rowViewModel as? BotResponseMembersViewModel {
            defHeight = vm.response.estimateFrameForText().height + vm.title.estimateFrameForText().height + 80
        } else if let vm = rowViewModel as? BotResponseChartViewModel {
            defHeight = vm.response.estimateFrameForText().height + 400
        }
        
        return defHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
