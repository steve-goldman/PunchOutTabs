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
        let type = CardTemplate.ClassTypes[classTypePicker.selectedRowInComponent(0)]
        let count = howManyClassesField.text!.toInt() ?? 0
        
        let pendingCard = PFUser.currentUser()!.pendingNewCard!
        
        // validate the new constraint
        let result = CardTemplateValidator.validate(pendingCard, type: type, count: count)
        if result.valid {
            // set the end date

            PFUser.currentUser()!.pendingNewCard = CardTemplate.createWithTypeCount(pendingCard, type: type, count: count)
            addActivityIndicator.startAnimating()
            PFUser.currentUser()!.pendingNewCard!.saveInBackgroundWithBlock { (success, error) in
                self.addActivityIndicator.stopAnimating()
                if success {
                    self.tableView.reloadData()
                } else {
                    UIAlertView(title: "Could not add type count", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        } else {
            UIAlertView(title: result.errorSection, message: result.errorMessage, delegate: nil, cancelButtonTitle: "Got it").show()
        }
    }
    
    @IBAction func donePressed() {
        let pendingCard = PFUser.currentUser()!.pendingNewCard!
        
        // validate
        let result = CardTemplateValidator.validate(pendingCard)
        if result.valid {
            // activate the card template
            PFUser.currentUser()!.pendingNewCard = CardTemplate.createAsActive(pendingCard)
            doneActivityIndicator.startAnimating()
            PFUser.currentUser()!.pendingNewCard!.saveInBackgroundWithBlock { (success, error) in
                self.doneActivityIndicator.stopAnimating()
                if success {
                    // create a card instance for this user and template
                    let cardInstance = CardInstance.create(user: PFUser.currentUser()!, cardTemplate: PFUser.currentUser()!.pendingNewCard!)
                    self.doneActivityIndicator.startAnimating()
                    cardInstance.saveInBackgroundWithBlock { (success, error) in
                        self.doneActivityIndicator.stopAnimating()
                        if success {
                            // unset the card as pending for this user
                            PFUser.currentUser()!.pendingNewCard = nil
                            self.doneActivityIndicator.startAnimating()
                            PFUser.currentUser()!.saveInBackgroundWithBlock { (success, error) in
                                self.doneActivityIndicator.stopAnimating()
                                if success {
                                    self.performSegueWithIdentifier(SegueIdentifier.Done, sender: nil)
                                } else {
                                    UIAlertView(title: "Could not do done", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                                }
                            }
                        } else {
                            UIAlertView(title: "Could not do done", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                        }
                    }
                } else {
                    UIAlertView(title: "Could not do done", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        } else {
            UIAlertView(title: result.errorSection, message: result.errorMessage, delegate: nil, cancelButtonTitle: "Got it").show()
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
        return PFUser.currentUser()!.pendingNewCard!.typeCounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TypeCounts, forIndexPath: indexPath) as! TypeCountsTableViewCell
        // TODO: inefficient
        let keys = Array(PFUser.currentUser()!.pendingNewCard!.typeCounts.keys)
        cell.type = keys[indexPath.row]
        cell.count = PFUser.currentUser()!.pendingNewCard!.typeCounts[keys[indexPath.row]]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // TODO: inefficient
            let keys = Array(PFUser.currentUser()!.pendingNewCard!.typeCounts.keys)
            PFUser.currentUser()!.pendingNewCard!.typeCounts.removeValueForKey(keys[indexPath.row])
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - UITextViewDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
