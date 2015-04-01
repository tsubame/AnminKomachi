//
//  UIOutlineLabel.swift
//  EarClerics
//
//  Created by hideki on 2014/11/21.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit

class UIOutlineLabel: UILabel {
    
    var innerOutlineColor = UIColor.whiteColor()
    var innerOutlineSize: CGFloat  = 2.0;
    
    var outerOutlineColor = UIColor.blackColor()
    var outerOutlineSize: CGFloat  = 4.0;
    
    
    // 初期化
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    
    override func drawTextInRect(rect: CGRect) {
        var cr = UIGraphicsGetCurrentContext()
        let textColor = self.textColor
        
        /*
        // 外枠を描画
        CGContextSetLineWidth(cr, outerOutlineSize)
        CGContextSetLineJoin(cr, kCGLineJoinRound)
        CGContextSetTextDrawingMode(cr, kCGTextStroke)
        self.textColor = outerOutlineColor
        super.drawTextInRect(rect)
        */
        // 内枠を描画
        CGContextSetLineWidth(cr, innerOutlineSize)
        CGContextSetLineJoin(cr, kCGLineJoinRound)
        CGContextSetTextDrawingMode(cr, kCGTextStroke)
        self.textColor = innerOutlineColor
        super.drawTextInRect(rect)
        // テキストを描画
        CGContextSetTextDrawingMode(cr, kCGTextFill)
        self.textColor = textColor
        super.drawTextInRect(rect)
    }

}