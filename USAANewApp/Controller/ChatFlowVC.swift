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

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return currentData[indexPath.row].question.estimateFrameForText().height + 30
    }

}

class ChatCell: UITableViewCell {
    
    
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?

    var detail: Detail? {
        didSet {
            if let detail = detail {
                
                question.text = detail.question
                question.textColor = .white
                question.textAlignment = .left
                bubbleView.backgroundColor = detail.isMemebr ? .appLightBlue : .appDarkBlue
                performUpdateConstarints()

            }
        }
    }
    
    private func performUpdateConstarints() {
        if let detail = detail {
            let isMember = detail.isMemebr
            bubbleLeftAnchor?.isActive = !isMember
            bubbleRightAnchor?.isActive = isMember
            bubbleHeightAnchor?.constant = detail.question.estimateFrameForText().height + 20
            bubbleWidthAnchor?.constant = detail.question.estimateFrameForText().width + 40
        }
    }
    
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
        
        let bubbleView: UIView = {
            let view = UIView()
            view.backgroundColor = .appDarkBlue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            return view
        }()
        
    
    override func awakeFromNib() {
                
        addSubview(bubbleView)
        addSubview(question)
        
        //x,y,w,h
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50)
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
    //       question.widthAnchor.constraintEqualToConstant(200).active = true
        
        question.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }
    
}
