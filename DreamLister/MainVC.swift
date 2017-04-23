//
//  MainVC.swift
//  DreamLister
//
//  Created by Ruben Sissing on 21/04/2017.
//  Copyright © 2017 Ruben Sissing. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var segment: UISegmentedControl!
    
    private var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        var typeIsEmpty: Bool {
            do {
                let request: NSFetchRequest<ItemType> = ItemType.fetchRequest()
                let count  = try context.count(for: request)
                return count == 0 ? true : false
            } catch {
                return true
            }
        }
        
        if typeIsEmpty {
            generateTestData()
        }
        
        attemptFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = self.controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = self.controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let typeSort = NSSortDescriptor(key: "toItemType", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = self.tableView.cellForRow(at: indexPath) as! ItemCell
                self.configureCell(cell: cell, indexPath: indexPath as IndexPath as NSIndexPath)
            }
        case.move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateTestData() {
        // Items
        let item = Item(context: context)
        item.title = "iPhone 8"
        item.price = 999
        item.details = "I can't wait until the July event, when they will update the iPhone."
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 379
        item2.details = "I can't wait to use my new Headphone."
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "This date will come in the near future."
        
        // Stores
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Argos"
        let store4 = Store(context: context)
        store4.name = "Amazon"
        let store5 = Store(context: context)
        store5.name = "Coolblue"
        let store6 = Store(context: context)
        store6.name = "Media Markt"
        
        // Types
        let type = ItemType(context: context)
        type.type = "Car"
        let type2 = ItemType(context: context)
        type2.type = "Electronic"
        let type3 = ItemType(context: context)
        type3.type = "Home"
        let type4 = ItemType(context: context)
        type4.type = "Toys"
        
        ad.saveContext()
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        self.attemptFetch()
        self.tableView.reloadData()
    }
    
}
