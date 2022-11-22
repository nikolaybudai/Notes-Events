//
//  EventsMainViewController.swift
//  Notes&Events
//
//  Created by Nikolay Budai on 4.11.22.
//

import UIKit
import CoreData

final class EventsMainViewController: UIViewController {

    //MARK: - Variables and Constants
    
    static let identifier = "EventsMainViewController"
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var eventsCountLabel: UILabel!
    
    private let searchController = UISearchController()
    
    private var fetchedResultsController: NSFetchedResultsController<Event>?
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Events"
        
        configureSearchBar()
        setupFetchedResultsController()
        configureEventsTableView()
        refreshEventsCountLabel()
    }
    
    //MARK: - Methods
    
    private func configureEventsTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    private func refreshEventsCountLabel() {
        guard let fetchedResultsController = fetchedResultsController else { return }

        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            eventsCountLabel.text = "\(count) \(count == 1 ? "event" : "events")"
        }
    }
    
    private func setupFetchedResultsController(filter: String? = nil) {
        fetchedResultsController = CoreDataManager.shared.createEventsFetchedResultsController(filter: filter)
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        refreshEventsCountLabel()
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
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

//MARK: - UITableViewDelegate and UITableViewDatasource

extension EventsMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let events = fetchedResultsController?.sections?[section] else { return 0 }
        return events.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = eventsTableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier) as? EventsTableViewCell
        else {
            return UITableViewCell()
        }
        
        let event = fetchedResultsController?.object(at: indexPath)
        
        cell.setup(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = fetchedResultsController?.object(at: indexPath) else { return }
        goToEditingEvent(event: event)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let event = fetchedResultsController?.object(at: indexPath) else { return }
            deleteEventFromStorage(event: event)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


//MARK: - NSFetchedResultsControllerDelegate

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
            eventsTableView.reloadData()
        case .update:
            if let indexPath = indexPath {
                eventsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            eventsTableView.reloadData()
        }
        
        refreshEventsCountLabel()
    }
    
}


//MARK: - UISearchBarDelegate

extension EventsMainViewController: UISearchBarDelegate {
    
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

        eventsTableView.reloadData()
    }
    
}
