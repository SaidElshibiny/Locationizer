//
//  NearbyViewController.swift
//  Locationizer
//
//  Created by Said on 2018-11-07.
//  Copyright © 2018 Said. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreLocation

class NearbyViewController: UIViewController, CLLocationManagerDelegate{
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Buttons
    @IBOutlet weak var restaurantsButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var sightseeingButton: UIButton!
    
    //Lables for buttons
    @IBOutlet weak var restaurantsLabel: UILabel!
    @IBOutlet weak var shoppingLabel: UILabel!
    @IBOutlet weak var sightseeingLabel: UILabel!
    
    
    
    //MARK: -IBActions
    @IBAction func restaurantsTapped(_ sender: Any) {
        
        //Set the background image to the restaurants image
        restaurantsButton.setBackgroundImage(UIImage(named: "Restaurants"), for: .normal)
        
        //set the tint and text color to white to reflect selected
        restaurantsButton.tintColor = UIColor.white
        restaurantsLabel.textColor = UIColor.white
        
        //change the other icons to refelct deselecting, change the tint and text to black
        shoppingButton.tintColor = UIColor.black
        sightseeingButton.tintColor = UIColor.black
        shoppingLabel.textColor = UIColor.black
        sightseeingLabel.textColor = UIColor.black
        
        //Query the businesses (Locations) with the term restaurant
        Business.searchWithTerm(term: "Restaurant", location: "\(theCoordinate)", completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                //update collectionView
                self.tableView.reloadData()
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
            self.animateTableView()
            }
        )
    }
    
    @IBAction func shoppingTapped(_ sender: Any) {
        
        //Set the background image to the shopping image
        shoppingButton.setBackgroundImage(UIImage(named: "Shopping"), for: .normal)
        
        //set the tint and text color to white to reflect selected
        shoppingButton.tintColor = UIColor.white
        shoppingLabel.textColor = UIColor.white
        
        //change the other icons to refelct deselecting, change the tint and text to black
        restaurantsButton.tintColor = UIColor.black
        sightseeingButton.tintColor = UIColor.black
        restaurantsLabel.textColor = UIColor.black
        sightseeingLabel.textColor = UIColor.black
        
        //Query the businesses (Locations) with the term shopping
        Business.searchWithTerm(term: "Shopping", location: "\(theCoordinate)", completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                //update collectionView
                self.tableView.reloadData()
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
                self.animateTableView()
            }
        )
    }
    
    //The sightseeing button tapped action
    @IBAction func sightseeingTapped(_ sender: Any) {
        
        //Set the background image to the sightseeing image
        sightseeingButton.setBackgroundImage(UIImage(named: "Sightseeing"), for: .normal)
        
        //set the tint and text color to white to reflect selected
        sightseeingButton.tintColor = UIColor.white
        sightseeingLabel.textColor = UIColor.white
        
        //change the other icons to refelct deselecting, change the tint and text to black
        restaurantsButton.tintColor = UIColor.black
        shoppingButton.tintColor = UIColor.black
        restaurantsLabel.textColor = UIColor.black
        shoppingLabel.textColor = UIColor.black
        
        //Query the businesses (Locations) with the term sightseeing
        Business.searchWithTerm(term: "Sightseeing", location: "\(theCoordinate)", completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                //update collectionView
                self.tableView.reloadData()
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
            self.animateTableView()
            }
        )
    }
    
    //MARK: - Variables and Constants
    
    //variable of instance business
    var businesses: [Business]!
    
    //Core Location variables
    let myManager = CLLocationManager()
    var myLatitude: CLLocationDegrees!
    var myLongitude: CLLocationDegrees!
    var theCoordinate = ""
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the setupLocationUpdates func
        setupLocationUpdates()
        
        //set the images for these buttons to the corresponding image
        restaurantsButton.setBackgroundImage(UIImage(named: "Restaurants"), for: .normal)
        shoppingButton.setBackgroundImage(UIImage(named: "Shopping"), for: .normal)
        sightseeingButton.setBackgroundImage(UIImage(named: "Sightseeing"), for: .normal)
        
        //Change the color of the
        restaurantsButton.tintColor = UIColor.white
        shoppingButton.tintColor = UIColor.black
        sightseeingButton.tintColor = UIColor.black
        
        //Change the color of the icon's text in the category view
        restaurantsLabel.textColor = UIColor.white
        shoppingLabel.textColor = UIColor.black
        sightseeingLabel.textColor = UIColor.black
        
        
        //assign self to the tableView delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        /*UI Changes to the tableView and the navigation controller
         remove the separators between cells in the tableview
         remove the separator between the navbar and the view*/
        tableView.separatorStyle = .none
        self.navigationController?.hidesNavigationBarHairline = true
        
    }
    
    //viewWillAppear function to implement the custom animation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateTableView()
    }
    

    /*method adds the appdelegate as the delegate for the location manager
     and verifies its authorization status. */
    func setupLocationUpdates(){
        myManager.delegate = self
        
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            myManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            startLocationTracking()
        default:
            break
        }
    }
    
    //Function to notify for authorization change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            startLocationTracking()
        }
    }
    
    //implement location tracking func
    func startLocationTracking(){
        //make sure the location services is enabled first
        if CLLocationManager.locationServicesEnabled(){
            myManager.startUpdatingLocation()
        }
    }
    
    //func to update the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        print(location)
        
        myLatitude = (location.coordinate.latitude)
        myLongitude = (location.coordinate.longitude)

        theCoordinate = "\(String(myLatitude)),\(String(myLongitude))"

        /*DEBUG CODE*/
//        print(location.coordinate.latitude)
//        print(myLatitude)
//
//        print(location.coordinate.longitude)
//        print(myLongitude)
//
//        print(theCoordinate)
        
        //Query the businesses (Locations) with the term restaurant
        Business.searchWithTerm(term: "Restaurant", location: "\(theCoordinate)", completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                //update collectionView
                self.tableView.reloadData()
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
                self.animateTableView()
            }
        )
        
        //stop updating the location
        manager.stopUpdatingLocation()
    }
    
//    //prepare segue to add items to the todoList when clicking the add button on the cardview locations
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let todoVC = segue.destination as? todoListViewController, let selectedIndex = tableView.indexPathForSelectedRow{
//
//            print(businesses[selectedIndex.row].name!)
//            print(businesses[selectedIndex.row].address!)
//
//            todoVC.business = businesses[selectedIndex.row]
//
//        }
//    }
    
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

//MARK: - Extensions
extension NearbyViewController: UITableViewDelegate{
    
    //implement methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //animate the deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension NearbyViewController: UITableViewDataSource{
    
    
    //Implement the required methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check if we have businesses
        if businesses != nil{
            return businesses.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create cell constant of dequeueReusableCell of the identifier NearbyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyCell", for: indexPath) as! NearbyTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        //return cell
        return cell
    }
    
}



