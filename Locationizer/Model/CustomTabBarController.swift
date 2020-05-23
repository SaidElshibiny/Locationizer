//
//  CustomTabBarController.swift
//  Locationizer
//
//  Created by Said Elshibiny on 2018-11-25.
//  Copyright © 2018 Said. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    //Create a propery that is an insatnce of the UITabBarItem
    var customTabBarItem = UITabBarItem()

    //create a view did load method to run our code
    override func viewDidLoad() {
        super.viewDidLoad()

        //code to change the text color of the tab bar icon and text
        
        //selected
        //XCODE 9: UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        //XCODE 10: UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        //Change the text color of the icon white if selected
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        //Change the text color of the icon to black if unselected
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
        /*NEARBY ICON*/

        //Create a propery and assign the white image of the nearby icon to it. Render image as original
        let selectedImage1 = UIImage(named: "nearby_icon_white")?.withRenderingMode(.alwaysOriginal)
        
        //Create a propery and assign the black image of the nearby icon to it. Render image as original
        let unselectedImage1 = UIImage(named: "nearby_icon_black")?.withRenderingMode(.alwaysOriginal)
        
        //Select the tab bar item number 1
        customTabBarItem = self.tabBar.items![0]
        
        //add the image unselected as the default
        customTabBarItem.image = unselectedImage1
        
        //change image to the white one when selected
        customTabBarItem.selectedImage = selectedImage1
        
        
        /*TODO LIST ICON*/
        
        //Create a propery and assign the white image of the to-do list icon to it. Render image as original
        let selectedImage2 = UIImage(named: "todoList_icon_white")?.withRenderingMode(.alwaysOriginal)
        
        //Create a propery and assign the black image of the to-do list icon to it. Render image as original
        let unselectedImage2 = UIImage(named: "todoList_icon_black")?.withRenderingMode(.alwaysOriginal)
        
        //Select the tab bar item number 2
        customTabBarItem = self.tabBar.items![1]
        
        //add the image unselected as the default
        customTabBarItem.image = unselectedImage2
        
        //change image to the white one when selected
        customTabBarItem.selectedImage = selectedImage2
        
        self.selectedIndex = 0
        
        
    }
}
