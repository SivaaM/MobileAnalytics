//
//  DetailVC.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 3/25/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit



class ChatFlowVC: UITableViewController {
    
    var currentData: [Detail] {
        return chatVM.currentData
    }
    lazy var chatVM: ChatViewModel = {
        return ChatViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    func injectChat(_ detail: Detail?) {
        if let detail = detail {
            chatVM.injectChat(detail)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.currentData.count > 1 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.currentData.count - 1, section: 0), at: .bottom, animated: true)

                }
           }
        }
    }
}

extension ChatFlowVC {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentData.count == 0 {
            self.tableView.setEmptyMessage("Hi, How Can I Help You?")
        } else {
            self.tableView.restore()
        }
        return currentData.count
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currentData.count
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        cell.detail = currentData[indexPath.row]
        return cell
    }

}

class ChatCell: UITableViewCell {
    
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    var detail: Detail? {
        didSet {
            if let detail = detail {
                
                question.text = detail.question
                question.textColor = .black
                question.textAlignment = detail.isMemebr ? .right : .left
//                question.backgroundColor = detail.isMemebr ? .gray : .darkGray
            }
        }
    }
    
    func calculateChatSize(_ string: String) {
        let width = string.width(withConstrainedHeight: question.frame.size.height, font: UIFont.systemFont(ofSize: 17))
        widthConstraint.constant = width
        
    }
    
    @IBOutlet weak var question: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
