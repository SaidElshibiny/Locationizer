//
//  todoListViewController.swift
//  Locationizer
//
//  Created by Said Elshibiny on 2018-11-24.
//  Copyright © 2018 Said. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class todoListViewController: UIViewController {

    //MARK: - IBOutlets
    
    //tableview
    @IBOutlet weak var tableView: UITableView!
    
    //searchbar
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    

    //MARK: - IBAction
    
    //Edit button tapped
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {

        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
             self.editButton.title = "Edit"
        }
        else
        {
            self.tableView.isEditing = true
             self.editButton.title = "Done"
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        //create a textfield for the alert
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Do List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when the user clicks the add item in the alert
            
            //set the title the textfield text, done as false and category as the selected category
            
            if textField.text == "" || textField.text == nil{
                
                let alert  = UIAlertController(title: "Empty Item", message: "Please add in text before clicking the add item button", preferredStyle: .alert)
                
                //cancel button in the alert
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(actionCancel)
                
                //present the alert
                self.present(alert, animated: true, completion: nil)
                
            } else{
                
                let newItem = TodoListItem(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            }
        }
        
        //cancel button in the alert
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) in

            //disbale the keybaord and search cursor
            //run on main thread
            DispatchQueue.main.async {
                alert.resignFirstResponder()
            }
            
        }
        
        //textfield inside the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        //add the actions to the alert
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        //present the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Variables and Constants
    
    //array of items
    var itemArray = [TodoListItem]()
    
    //access the view context of the persistent container from the app delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var business: Business!
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //print the location of the data model file to check with datum to check CRUD
//       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // assign self to the tableview delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        //assign self to the searchBar delegate
        searchBar.delegate = self
        searchBar.placeholder = "Filter items by title"
        
        //load the items
        loadItems()
        
        //remove the seperators in the tableview
        tableView.separatorStyle = .none
        
        self.navigationController?.hidesNavigationBarHairline = true
        
        
//            if self.business.name == "" || self.business.name == nil || self.business.address == "" || self.business.address == nil{
//
//                    let alert  = UIAlertController(title: "Can't add location", message: "please fix", preferredStyle: .alert)
//
//                    //cancel button in the alert
//                    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
//
//                    alert.addAction(actionCancel)
//
//                    //present the alert
//                    self.present(alert, animated: true, completion: nil)
//
//                } else{
//
//                    let newItem = TodoListItem(context: self.context)
//                    newItem.title = "Visit \(String(business.name!)) at \(String(business.address!))"
//                    newItem.done = false
//                    self.itemArray.append(newItem)
//                    self.saveItems()
//
//                }
    }
    
    //view willappear to add the custom animation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateTableView()
    }
    
    //save items functions
    func saveItems(){
        
        do{
           try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //load items function
    //allow the loadItem to take in a request parameter of type nsfetchrequest. default to fetch all items
    func loadItems(withRequest request:NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()){
    
        //do/catch block to fetch and catch an error if present
        do{
            //save the results inside the array
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from the context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //function for adding items to the todoList from nearby view controller
    func populatetodoListFromNearby(name businessName: String, address businessAdress: String ){
        
        let newItem = TodoListItem(context: self.context)
        
        newItem.title = "Visit \(businessName) at \(businessAdress)"
        newItem.done = false
        
        itemArray.append(newItem)
        saveItems()
        
    }
    
    //Custom Animation Function
    func animateTableView(){
        
        //reload data
        tableView.reloadData()
        
        //create a property that holds all the visible cells in the tableView
        let cells = tableView.visibleCells
        
        //get the height of the tableView
        let tableViewHeight = tableView.bounds.size.height
        
        //iterate over each cell using a for in loop and move it offscreen based on the tableViewHeight
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        /*create a property called delay counter
        that will act as the delay in the cell animations*/
        var delayCounter = 0
        
        //create a for in loop that will performs the animation for each cell
        for cell in cells{
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                //set the transform property of the cell to original form (identity)
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            //increment the delay counter
            delayCounter += 1
        }
    }
    
}
//MARK: - Extensions
extension todoListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //set the done property to the opposite of what it is (checkmark)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //save the change to refelct update
        saveItems()
        
        //animate the deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension todoListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the count of the item array
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! SwipeTableViewCell
        
        //create an item property with the current indexpath.row
        let item = itemArray[indexPath.row]
        
        //set the cell text to the current item title
        cell.textLabel?.text = item.title
        
        //if item.done = true then set the cell.accessoryType to checkmark else set to none
        cell.accessoryType = item.done ? .checkmark : .none
        
        //randomize the background color of the each item (First implementation)
//        cell.backgroundColor = UIColor(hexString: itemArray[indexPath.row].color ?? "A7D85E")

        /*Optional binding
        /Use the flatgreen func of the framework that returns green and then darken the color by indexpath.row/number of items
        Change the text color based on the background color*/
        if let color = FlatGreen().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
    
//        cell.delegate = self as! SwipeTableViewCellDelegate
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //delete the item from context first
            self.context.delete(self.itemArray[indexPath.row])
            
            //remove the item in that indexpath row after removing from the context to avoid error
            self.itemArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //save the change to refelct update
            do{
                try self.context.save()
            }catch{
                print("Error saving context \(error)")
            }
            
        }
        
    }
    
    
}

//extension for search bar delegate
extension todoListViewController: UISearchBarDelegate{
    
    //func to check if the search button was clicked, to start query
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" || searchBar.text == nil{
            
            let alert  = UIAlertController(title: "Invalid Search", message: "Please add in text before clicking the search button", preferredStyle: .alert)
            
            //cancel button in the alert
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(actionCancel)
            
            //present the alert
            present(alert, animated: true, completion: nil)
            
        }else{
            //create a request
            let request : NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
            
            //create a NSPredicate to query. look for the item with the text from the search bar text.
            //[cd] to make it insensitive to case and diacritic
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            //create a sort descriptor, to sort the data retrieved. ascending alphabatical order
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            //call the load items with the request, to run the request and fetch results
            loadItems(withRequest: request)
        }
        
        
    }
    
    //func for when the text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //check if the text inside the searchBar has changed and is equal to zero
        if searchBar.text?.count == 0{
            //fetch all the items
            loadItems()
        
            //disbale the keybaord and search cursor
            //run on main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}

/*DOESN'T WORK WITH XCODE 9 + Even if commented out will not work, because I commented out class methods to avoid error */

////extension for SwipeTableViewDelegate to delete rows
//extension todoListViewController: SwipeTableViewCellDelegate{
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        //make sure the swipe is from the right
//        guard orientation == .right else { return nil }
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            
//            //delete the item from context first
//            self.context.delete(self.itemArray[indexPath.row])
//            
//            //remove the item in that indexpath row after removing from the context to avoid error
//            self.itemArray.remove(at: indexPath.row)
//            
//            //save the change to refelct update
//            do{
//                try self.context.save()
//            }catch{
//                print("Error saving context \(error)")
//            }
//            
//        }
//        
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
//        
//        return [deleteAction]
//    }
//    
//    //swiping all the way to delete the item
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions{
//        var options = SwipeOptions()
//        //this removes the item and adds an animation
//        options.expansionStyle = .destructive
//        return options
//    }
//    
//    
//}
