//
//  ViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 22.10.22.
//

import UIKit

final class WelcomeViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var myNotesButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        NotificationsManager.shared.requestAuthorization()
    }
    
    //MARK: - Methods
    
    private func configureButtons() {
        myNotesButton.layer.cornerRadius = 15
        myEventsButton.layer.cornerRadius = 15
    }

    //MARK: - Actions
    
    @IBAction func myNotesButtonTapped(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: NotesMainViewController.identifier) as? NotesMainViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func myEventsButtonTapped(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: EventsMainViewController.identifier) as? EventsMainViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

