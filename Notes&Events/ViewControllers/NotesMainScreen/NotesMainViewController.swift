//
//  NotesMainViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 28.10.22.
//

import UIKit
import CoreData

class NotesMainViewController: UIViewController {

    //MARK: - Variables and Constants
    
    static let identifier = "NotesMainViewController"
    
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var notesCountLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let searchController = UISearchController()
    
    private var fetchedResultsController: NSFetchedResultsController<Note>?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Notes"
        
        configureSearchBar()
        setupFetchedResultsController()
        configureNotesTableView()
        refreshNotesCountLabel()
    }
    
    //MARK: - Methods
    
    private func configureNotesTableView() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    private func refreshNotesCountLabel() {
        guard let fetchedResultsController = fetchedResultsController else { return }
        
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            notesCountLabel.text = "\(count) \(count == 1 ? "note" : "notes")"
        }
    }
    
    private func setupFetchedResultsController(filter: String? = nil) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchedResultsController = CoreDataManager.shared.createNotesFetchResultsController(filter: filter, isSortedByPriority: false)
        case 1:
            fetchedResultsController = CoreDataManager.shared.createNotesFetchResultsController(filter: filter, isSortedByPriority: true)
        default:
            fetchedResultsController = CoreDataManager.shared.createNotesFetchResultsController(filter: filter, isSortedByPriority: false)
        }
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        refreshNotesCountLabel()
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    private func goToNoteEditing(note: Note) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: NoteDetailViewController.identifier) as? NoteDetailViewController
        else { return }
        controller.note = note
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        return note
    }
    
    private func deleteNoteFromStorage(note: Note) {
        CoreDataManager.shared.deleteNote(note)
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        goToNoteEditing(note: createNote())
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        setupFetchedResultsController()
        notesTableView.reloadData()
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource

extension NotesMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notes = fetchedResultsController?.sections?[section] else { return 0 }
        return notes.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = notesTableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as? NoteTableViewCell
        else {
            return UITableViewCell()
        }
        
        let note = fetchedResultsController?.object(at: indexPath)
        
        cell.setup(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = fetchedResultsController?.object(at: indexPath) else { return }
        goToNoteEditing(note: note)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let note = fetchedResultsController?.object(at: indexPath) else { return }
            deleteNoteFromStorage(note: note)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - NSFetchedResultControllerDelegate

extension NotesMainViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                notesTableView.insertRows(at: [newIndexPath], with: .automatic)
                notesTableView.reloadData()
            }
        case .delete:
            if let indexPath = indexPath {
                notesTableView.deleteRows(at: [indexPath], with: .automatic)
                notesTableView.reloadData()
            }
        case .move:
            if let indexPath = indexPath,
            let newIndexPath = newIndexPath {
                notesTableView.moveRow(at: indexPath, to: newIndexPath)
            }
            notesTableView.reloadData()
        case .update:
            if let indexPath = indexPath {
                notesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            notesTableView.reloadData()
        }
        
        refreshNotesCountLabel()
    }
}

//MARK: - UISearchController Configuration

extension NotesMainViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar.text ?? "")
    }
    
    func search(_ query: String) {
        if query.count >= 1 {
            setupFetchedResultsController(filter: query)
        } else {
            setupFetchedResultsController()
        }
        
        notesTableView.reloadData()
    }
    
}
