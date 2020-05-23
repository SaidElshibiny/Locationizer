//
//  CardView.swift
//  Locationizer
//
//  Created by Said on 2018-12-06.
//  Copyright © 2018 Said. All rights reserved.
//

import Foundation
import UIKit

/*This class changes the view to look like a card view for the nearby view controller*/

@IBDesignable class CardView: UIView{
    
    /*
     Change:
     Corner radius
     ShadowColor
     ShadowOffSetWidth
     ShadowOffSetHeight
     ShadowOpacity
     */
    
    //Creating them as an IBInspectable allows easy changes from the attributes inspector
    
    @IBInspectable var cornerRadius : CGFloat = 10
    @IBInspectable var shadowColor : UIColor? = UIColor.black
    @IBInspectable var shadowOffSetWidth : Int = 0
    @IBInspectable var shadowOffSetHeight : Int = 1
    @IBInspectable var shadowOpacity : CGFloat = 0.2
    
    //override the layoutsubviews func to change the view bases on the variables created
    override func layoutSubviews() {
        
        //Change the layers corner radius, shadowcolor, shadowoffset
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        //create variable shadowpath for the path of the shadow
        var shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        //add the shadow path to the layer
        layer.shadowPath = shadowPath.cgPath
        
        //add the shadowopacity to the layer
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
