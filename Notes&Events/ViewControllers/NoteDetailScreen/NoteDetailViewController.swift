//
//  NoteDetailViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 29.10.22.
//

import UIKit

final class NoteDetailViewController: UIViewController {

    //MARK: - Variables and Constants
    
    static let identifier = "NoteDetailViewController"
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var note: Note?
    
    private var tapGestureRecognizer = UITapGestureRecognizer()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNoteInfo()
        configureSegmentedControl()
        configureTapGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        noteTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

         saveNote()
    }

    //MARK: - Methods
    
    private func setupNoteInfo() {
        if let note = note {
            noteTextView.text = note.text
            segmentedControl.selectedSegmentIndex = Int(note.priority.rawValue)
        }
    }
    
    private func configureTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        noteTextView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureSegmentedControl() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    private func updateNote() {
        if let note = note {
            note.lastUpdated = Date()
        }
        CoreDataManager.shared.saveContext()
    }
    
    private func deleteNote() {
        if let note = note {
            CoreDataManager.shared.deleteNote(note)
        }
    }
    
    func saveNote() {
        guard let note = note else { return }
        
        note.text = noteTextView.text

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            note.priority = PriorityType.low
        case 1:
            note.priority = PriorityType.middle
        case 2:
            note.priority = PriorityType.high
        default:
            note.priority = .low
        }
        if note.text?.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
