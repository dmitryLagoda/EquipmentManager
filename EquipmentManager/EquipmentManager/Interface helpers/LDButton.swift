//
//  LDButton.swift
//  Denovo Collaborate
//
//  Created by MacBook on 3/3/15.
//  Copyright (c) 2015 Denovo. All rights reserved.
//

import UIKit

class LDButton: UIButton
{
    override var highlighted: Bool
        {
        didSet
        {
            if (highlighted)
            {
                self.backgroundColor = UIColor(red: 1/255, green: 149/255, blue: 215/255, alpha: 1)
            }
            else
            {
                self.backgroundColor = UIColor(red: 2/255, green: 83/255, blue: 155/255, alpha: 1.0)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
    }
}