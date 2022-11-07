//
//  EventsTableViewCell.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit

final class EventsTableViewCell: UITableViewCell {
    
    static let identifier = "EventCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    func setup(event: Event?) {
        titleLabel.text = event?.title?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first
        
        if let date = event?.date {
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
}
