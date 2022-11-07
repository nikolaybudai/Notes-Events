//
//  EventsDetailViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit

final class EventsDetailViewController: UIViewController {

    //MARK: - Variables and Constants
    
    static let identifier = "EventsDetailViewController"
    
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scheduleButton: UIButton!
    
    var event: Event?
    
    private var tapGestureRecognizer = UITapGestureRecognizer()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEventInfo()
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
    
    private func setupEventInfo() {
        if let event = event {
            eventTextView.text = event.title
            datePicker.date = event.date ?? Date()
        }
    }
    
    private func configureTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        eventTextView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateEvent() {
        if let event = event {
            event.date = datePicker.date
        }
        CoreDataManager.shared.saveContext()
    }
    
    private func deleteEvent() {
        if let event = event {
            CoreDataManager.shared.deleteEvent(event)
        }
    }
    
    private func saveEvent() {
        guard let event = event else { return }

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
            NotificationsManager.shared.scheduleNotification(title: "Don't forget!",
                                                             body: eventTextView.text,
                                                             date: datePicker.date)
            
            alertController = NotificationsManager.shared.createConfirmingAlertController(date: datePicker.date)
        } else {
            alertController = NotificationsManager.shared.createNotificationDisabledAlertController()
        }
        
        present(alertController, animated: true)
    }
    
}
