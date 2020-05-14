//
//  Utils.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation
import UIKit

enum VoiceResponse<T, V> {
    case respose(T, V)
    case confirm
}

protocol SpeechDataDelegate: class {
    func voiceInput(_ string: String?)
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func estimateFrameForText() -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "TrebuchetMS", size: 20)!]), context: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
}


extension UIColor {
    static let appDarkBlue = UIColor(red: 18/255.0, green: 56/255.0, blue: 92/255.0, alpha: 1.0)
    static let appLightBlue = UIColor(red: 16/255.0, green: 153/255.0, blue: 189/255.0, alpha: 1.0)
    static let appLightGray = UIColor(red: 233/255.0, green: 233/255.0, blue: 225/255.0, alpha: 1.0)

}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}


extension UIViewController {
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}

struct DialogueMockResponse: Codable {
    let resolvedQuery: String
    let intentName: String
    let responseImage: String
    let speech: String
    let group: String?
    let filter_date: String?
    let filter_memberStatus: String?
    let filter_militaryRank: String?
    let intentType: String
}

struct DialogueResponse: Codable {
    struct Metadata: Codable {
        let intentName: String?
    }
    struct Fulfillment: Codable {
        let speech: String?
    }
    struct Parameters: Codable {
        let filter_date: String?
        let filter_memberStatus: String?
        let group: [String]?
        let filter_militaryRank: String?
    }
    struct Result: Codable {
        let resolvedQuery: String?
        let parameters: Parameters?
    }
    let metadata: Metadata?
    let fulfillment: Fulfillment?
    let parameters: Parameters?
    let result: Result?

}

struct MemberInfoResponse: Codable {
    let data: [DataSec]
    let columns: [ColumnsData]
}

struct DataSec: Codable {
    let c1: String
    let c2: String?
}

struct ColumnsData: Codable {
    let column: String
    let title: String
}

extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

}

extension UITableViewCell {
    /// Generated cell identifier derived from class name
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

struct FileLoader {
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

typealias VoiceResponseBlock = ((VoiceResponse<DialogueMockResponse, MemberInfoResponse>) -> ())

extension UIView {
    /// Generating constraints to superview's edge
    func edgeConstraints(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: self.superview!.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor, constant: -right),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: -bottom)
        ]
    }
}
