//
//  EventsDetailViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit

class EventsDetailViewController: UIViewController {

    //MARK: - Variables and Constants
    
    static let identifier = "EventsDetailViewController"
    
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scheduleButton: UIButton!
    
    var event: Event!
    
    private var tapGestureRecognizer = UITapGestureRecognizer()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTextView.text = event.title
        datePicker.date = event.date ?? Date()
        configureTapGestureRecognizer()
        configureScheduleButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        saveEvent()
    }
    
    //MARK: - Methods
    
    private func configureScheduleButton() {
        scheduleButton.layer.cornerRadius = 15
    }
    
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
    
    //MARK: - Actions
    
    @IBAction func scheduleButtonTapped(_ sender: Any) {
        
        let isAuthorized = NotificationsManager.shared.isStatusAuthorized()
        var alertController = UIAlertController()
        
        if isAuthorized {
            NotificationsManager.shared.scheduleNotification(title: "Dont't forget", body: eventTextView.text, date: datePicker.date)
            alertController = NotificationsManager.shared.createConfirmingAlertController(date: datePicker.date)
        } else {
            alertController = NotificationsManager.shared.createNotificationDisabledAlertController()
        }
        
        present(alertController, animated: true)
    }
    
}
