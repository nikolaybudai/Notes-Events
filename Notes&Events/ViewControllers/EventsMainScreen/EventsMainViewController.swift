//
//  EventsMainViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit
import CoreData

class EventsMainViewController: UIViewController {

    static let identifier = "EventsMainViewController"
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var eventsCountLabel: UILabel!
    
    private var fetchedResultsController: NSFetchedResultsController<Event>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Events"
        
        setupFetchedResultsController()
        refreshEventsCountLabel()
    }
    
    //MARK: - Methods
    
    private func refreshEventsCountLabel() {
        let count = fetchedResultsController.sections![0].numberOfObjects
        eventsCountLabel.text = "\(count) \(count == 1 ? "note" : "notes")"
    }
    
    private func setupFetchedResultsController() {
        fetchedResultsController = CoreDataManager.shared.createEventsFetchedResultsController()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func goToEditingEvent(event: Event) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: EventsDetailViewController.identifier) as? EventsDetailViewController else { return }
        controller.event = event
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func createEvent() -> Event {
        let event = CoreDataManager.shared.createEvent()
        return event
    }
    
    private func deleteEventFromStorage(event: Event) {
        CoreDataManager.shared.deleteEvent(event)
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        goToEditingEvent(event: createEvent())
    }
    
}


extension EventsMainViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        eventsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        eventsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                eventsTableView.insertRows(at: [newIndexPath], with: .automatic)
                eventsTableView.reloadData()
            }
        case .delete:
            if let indexPath = indexPath {
                eventsTableView.deleteRows(at: [indexPath], with: .automatic)
                eventsTableView.reloadData()
            }
        case .move:
            if let indexPath = indexPath,
            let newIndexPath = newIndexPath {
                eventsTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                eventsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            eventsTableView.reloadData()
        }
        
    }
    
}
