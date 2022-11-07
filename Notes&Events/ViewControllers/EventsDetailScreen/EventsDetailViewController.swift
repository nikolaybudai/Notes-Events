//
//  EventsDetailViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit

class EventsDetailViewController: UIViewController {

    static let identifier = "EventsDetailViewController"
    
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var event: Event!
    
    private var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTextView.text = event.title
        configureTapGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveEvent()
    }
    
    //MARK: - Methods
    
    private func configureTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        eventTextView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateEvent() {
        event.date = datePicker.date
        CoreDataManager.shared.saveContext()
    }
    
    private func deleteEvent() {
        CoreDataManager.shared.deleteEvent(event)
    }
    
    private func saveEvent() {
        event.title = eventTextView.text
        
        if event.title?.isEmpty ?? true {
            deleteEvent()
        } else {
            updateEvent()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
