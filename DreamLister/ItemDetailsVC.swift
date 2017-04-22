//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ruben Sissing on 21/04/2017.
//  Copyright © 2017 Ruben Sissing. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet private var storePicker: UIPickerView!
    @IBOutlet private var titleField: CustomTextField!
    @IBOutlet private var priceField: CustomTextField!
    @IBOutlet private var detailsField: CustomTextField!
    @IBOutlet private var deleteButton: UIBarButtonItem!
    @IBOutlet private var thumbImg: UIImageView!
    
    private var stores = [Store]()
    var itemToEdit: Item?
    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.storePicker.delegate = self
        self.storePicker.dataSource = self
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        
        UITextField.connectFields(fields: [self.titleField, self.priceField, self.detailsField])
        
        self.getStores()
        
        if itemToEdit != nil {
            self.loadItemData()
            self.deleteButton.isEnabled = true
        } else {
            self.deleteButton.isEnabled = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = self.stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            
        }
    }
    
    func loadItemData() {
        if let item = self.itemToEdit {
            self.titleField.text = item.title
            self.priceField.text = "\(item.price)"
            self.detailsField.text = item.details
            self.thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = self.stores[index]
                    if s.name == store.name {
                        self.storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < self.stores.count)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.thumbImg.image = img
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        if self.itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = self.itemToEdit
        }
        
        item.toImage = picture
        
        if let title = self.titleField.text {
            item.title = title
        }
        
        if let price = self.priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = self.detailsField.text {
            item.details = details
        }
        
        item.toStore = self.stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
}
