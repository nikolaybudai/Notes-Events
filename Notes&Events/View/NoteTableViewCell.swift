//
//  NoteTableViewCell.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 28.10.22.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {

    static let identifier = "NoteCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var priorityImageView: UIImageView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func setup(note: Note?) {
        titleLabel.text = note?.text?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first
        if let lastUpdated = note?.lastUpdated {
            lastUpdatedLabel.text = dateFormatter.string(from: lastUpdated)
        }
        switch note?.priority {
        case .high:
            priorityImageView.image = UIImage(named: "high")
        case .middle:
            priorityImageView.image = UIImage(named: "middle")
        case .low:
            priorityImageView.image = UIImage(named: "low")
        default:
            break
        }
    }
}
