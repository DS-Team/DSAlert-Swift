//
//  DSTableCell.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/8/31.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import UIKit

let DSASCellIdentifier : String = "DSTableCell"


class DSTableCell: UITableViewCell {

    //MARK: - IBOutlet
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        
        CGContextFillRect(context, rect)
        
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(white: 0.8, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRect(x: 0.0, y: CGRectGetHeight(rect), width: CGRectGetWidth(rect), height: 0.25))
    }
    
}
