//
//  NearbyTableViewCell.swift
//  Locationizer
//
//  Created by Said Elshibiny on 2018-11-17.
//  Copyright © 2018 Said. All rights reserved.
//

import UIKit

class NearbyTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    //All the outlets needed to correspond with the business model
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    //MARK: - Variabels
    
    //Create a property called business of the type Business
    var business: Business!{
        //create observer
        didSet{
            //populate the view
            locationImageView.setImageWith(business.imageURL!)
            locationLabel.text = business.name
            ratingImageView.image = business.ratingImage
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            distanceLabel.text = business.distance
            addressLabel.text = business.address
            categoryLabel.text = business.categories
    
        }
    }
    
    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //Round the corner of the location image
        locationImageView.layer.cornerRadius = 10
        
        //round only the top left and right corners
        locationImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
}


