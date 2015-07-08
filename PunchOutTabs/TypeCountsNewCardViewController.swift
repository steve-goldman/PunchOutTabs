//
//  ClassesOfTypeOfNewCardViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class TypeCountsNewCardViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let Add = "Add"
        static let Done = "Done"
    }
    
    private struct CellIdentifier
    {
        static let TypeCounts = "Type Counts"
    }

    // MARK: - Properties
    
    @IBOutlet weak var howManyClassesField: UITextField! {
        didSet {
            howManyClassesField.delegate = self
            howManyClassesField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var classTypePicker: UIPickerView! {
        didSet {
            classTypePicker.dataSource = self
            classTypePicker.delegate = self
        }
    }
    
    @IBOutlet weak var addActivityIndicator: UIActivityIndicatorView! {
        didSet {
            addActivityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var doneActivityIndicator: UIActivityIndicatorView! {
        didSet {
            doneActivityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addPressed()
    {
        if let count = howManyClassesField.text!.toInt() {
            let type = CardTemplate.ClassTypes[classTypePicker.selectedRowInComponent(0)]
            addTypeCount(type: type, count: count)
        }
    }
    
    @IBAction func donePressed() {
        // activate the card template
        PFUser.currentUser()!.pendingNewCard!.isActive = true
        doneActivityIndicator.startAnimating()
        PFUser.currentUser()!.pendingNewCard!.saveInBackgroundWithBlock { (success, error) in
            self.doneActivityIndicator.stopAnimating()
            if success {
                self.performSegueWithIdentifier(SegueIdentifier.Done, sender: nil)
            } else {
                PFUser.currentUser()!.pendingNewCard!.isActive = false
                UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.Add {
            // nothing to do here
        } else if segue.identifier == SegueIdentifier.Done {
            let tabBarController = segue.destinationViewController as! MustLoginTabBarController
            tabBarController.selectMyCards()
            tabBarController.alertView = UIAlertView(title: "Card created", message: "Go stamp your new card!", delegate: nil, cancelButtonTitle: "Continue")
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CardTemplate.ClassTypes.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return CardTemplate.ClassTypes[row]
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PFUser.currentUser()!.pendingNewCard!.getTypes().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TypeCounts, forIndexPath: indexPath) as! TypeCountsTableViewCell
        cell.type = Array(PFUser.currentUser()!.pendingNewCard!.getTypes())[indexPath.row]
        cell.count = PFUser.currentUser()!.pendingNewCard!.getCountForType(cell.type!)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let type = Array(PFUser.currentUser()!.pendingNewCard!.getTypes())[indexPath.row]
            removeType(type)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - UITextViewDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Adding/Removing type counts
    
    private func addTypeCount(#type: String, count: Int) {
        PFUser.currentUser()!.pendingNewCard!.setType(type, count: count)
        addActivityIndicator.startAnimating()
        PFUser.currentUser()!.pendingNewCard!.saveInBackgroundWithBlock { (success, error) in
            self.addActivityIndicator.stopAnimating()
            if success {
                self.tableView.reloadData()
            } else {
                PFUser.currentUser()!.pendingNewCard!.unsetType(type)
                UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
    
    private func removeType(type: String) {
        let oldCount = PFUser.currentUser()!.pendingNewCard!.getCountForType(type)
        PFUser.currentUser()!.pendingNewCard!.unsetType(type)
        addActivityIndicator.startAnimating()
        PFUser.currentUser()!.pendingNewCard!.saveInBackgroundWithBlock { (success, error) in
            self.addActivityIndicator.stopAnimating()
            if success {
                self.tableView.reloadData()
            } else {
                PFUser.currentUser()!.pendingNewCard!.setType(type, count: oldCount)
                UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
}
