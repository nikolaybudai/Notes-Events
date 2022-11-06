//
//  EventsDetailViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit

class EventsDetailViewController: UIViewController {

    static let identifier = "EventsDetailViewController"
    
    @IBOutlet weak var eventsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
