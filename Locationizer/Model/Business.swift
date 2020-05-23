//
//  Business.swift
//  Locationizer
//
//  Created by Said Elshibiny on 2018-11-17.
//  Copyright © 2018 Said. All rights reserved.
//

import UIKit

//Create a class that will be the model of the businesses retrieved with the api
class Business: NSObject {
    
    //Create the basic constants that are needed
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImage: UIImage?
    let reviewCount: NSNumber?
    
    //Create an init that will have a dictionary
    init(dictionary: NSDictionary) {
        
        //Name constant as a dictionary
        name = dictionary["name"] as? String
        
        //Image (location Image) as dictionary image_url
        let imageURLString = dictionary["image_url"] as? String
        
        /*if the image url not nil then set the image url to the url retrieved
        else return nill*/
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        //the location address
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["display_address"] as? NSArray
            if addressArray != nil {
                if addressArray!.count > 0 {
                    address = addressArray![0] as! String
                }
                if addressArray!.count > 1 {
                    address += ", " + (addressArray![1] as! String)
                }
            }
        }
        self.address = address
        
        //The categories
        let categoriesArray = dictionary["categories"] as? [NSDictionary]
        /*if not nil create a array of category names and add the categories
         each category seperated by a comma. Else return nil*/
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category["title"] as! String
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        //The distance
        let distanceMeters = dictionary["distance"] as? NSNumber
        //If not nil calculate the conversion and add mi to the distance string, else return nil
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        //The rating image
        let rating = dictionary["rating"] as? Double
        /*If not nil then create a swith statement that returns the correspondin image of the starts (rating)
         based on the case number. default to zero stars image*/
        if rating != nil {
            switch rating {
            case 1:
                self.ratingImage = UIImage(named: "stars_1")
                break
            case 1.5:
                self.ratingImage = UIImage(named: "stars_1half")
                break
            case 2:
                self.ratingImage = UIImage(named: "stars_2")
                break
            case 2.5:
                self.ratingImage = UIImage(named: "stars_2half")
                break
            case 3:
                self.ratingImage = UIImage(named: "stars_3")
                break
            case 3.5:
                self.ratingImage = UIImage(named: "stars_3half")
                break
            case 4:
                self.ratingImage = UIImage(named: "stars_4")
                break
            case 4.5:
                self.ratingImage = UIImage(named: "stars_4half")
                break
            case 5:
                self.ratingImage = UIImage(named: "stars_5")
                break
            default:
                self.ratingImage = UIImage(named: "stars_0")
                break
            }
        } else {
            self.ratingImage = UIImage(named: "stars_0")
        }
        
        //Assign the review count to dictionary number
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    //create a func of all the dictionaries and append the every business to the array businesses
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    //func for search term and location required
    class func searchWithTerm(term: String, location: String,  completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, location: location, completion: completion)
    }
    
    //func for search term and location required
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, location: String,  completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, openNow: false, location: location, completion: completion)
    }
}
