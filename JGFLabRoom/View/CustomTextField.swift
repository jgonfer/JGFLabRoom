//
//  CustomTextField.swift
//  JGFLabRoom
//
//  Created by Josep González on 27/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class CustomTextField : UITextField {
    var leftTextMargin : CGFloat = 0.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        newBounds.size.width -= leftTextMargin*3
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        newBounds.size.width -= leftTextMargin*3
        return newBounds
    }
}
