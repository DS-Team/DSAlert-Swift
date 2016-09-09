//
//  DSActionSheet.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/8/31.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import UIKit

public enum DSCustomActionSheetStyle : Int {
    
    /*!
     *  普通样式
     */
    case DSCustomActionSheetStyleNormal
    /*!
     *  带标题样式
     */
    case DSCustomActionSheetStyleTitle
    /*!
     *  带图片和标题样式
     */
    case DSCustomActionSheetStyleImageAndTitle
    /*!
     *  带图片样式
     */
    case DSCustomActionSheetStyleImage
}

class DSActionSheet: UIView,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - property
    /*! 数据源 */
    var dataArray = [String]()
    /*! 图片数组 */
    var imageArray = [UIImage]?()
    /*! 标记颜色是红色的那行 */
    var specialIndex : Int = 0
    /*! 标题 */
    var headerTitle = String?()
    /*! 点击事件回调 */
    var callback:Int -> Void = {_ in }
    /*! 自定义样式 */
    var viewStyle : DSCustomActionSheetStyle = .DSCustomActionSheetStyleNormal
    
    var viewWidth : CGFloat {
        get {
            return CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
    }
    
    var viewHeight : CGFloat {
        get {
            return CGRectGetHeight(UIScreen.mainScreen().bounds)
        }
    }
    
    static func shareActionSheet() -> DSActionSheet {
        
        let actionSheet = DSActionSheet()
        
        let autoresizing : UIViewAutoresizing = [.FlexibleBottomMargin , .FlexibleLeftMargin , .FlexibleRightMargin, .FlexibleWidth]
        
        actionSheet.autoresizingMask = autoresizing
        
        actionSheet.imageArray = nil
        
        actionSheet.specialIndex = -1
        
        actionSheet.headerTitle = nil
        
        return actionSheet
    }
    
    //MARK: - 外部初始化方法
    static func ds_showActionSheetWithStyle(style style:DSCustomActionSheetStyle,
                                                  contentArray:[String]!,
                                                  imageArray:[UIImage]!,
                                                  redIndex:Int,
                                                  title:String?,
                                                  ButtonActionBlock:(Int) -> Void) {
        
        let actionSheet = DSActionSheet.shareActionSheet()
        
        actionSheet.dataArray                   = contentArray
        actionSheet.viewStyle                   = style
        actionSheet.imageArray                  = imageArray
        actionSheet.specialIndex                = redIndex
        actionSheet.headerTitle                 = title
        actionSheet.callback                    = ButtonActionBlock
        
        actionSheet.tableView.reloadData()
        actionSheet.show()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section
        {
            if (viewStyle == .DSCustomActionSheetStyleNormal || viewStyle == .DSCustomActionSheetStyleImage)
            {
                return dataArray.count
            }
            else
            {
                return dataArray.count + 1
            }
        }
        else
        {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ( 0 == section ) ? 8.0 : 0.1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DSASCellIdentifier, forIndexPath: indexPath) as! DSTableCell
        
        cell.selectionStyle = ( headerTitle != nil && 0 == indexPath.row ) ? UITableViewCellSelectionStyle.None : UITableViewCellSelectionStyle.Default
        
        if 0 == indexPath.section
        {
            if indexPath.row == specialIndex
            {
                cell.customTextLabel.textColor = UIColor.redColor()
            }
            
            if viewStyle == .DSCustomActionSheetStyleNormal
            {
                cell.customTextLabel.text = dataArray[indexPath.row]
            }
            else if viewStyle == .DSCustomActionSheetStyleTitle
            {
                cell.customTextLabel.text = ( 0 == indexPath.row ) ? headerTitle : dataArray[indexPath.row-1]
            }
            else
            {
                
                let index : Int = ( headerTitle == nil ) ? indexPath.row : indexPath.row - 1
                
                if index >= 0
                {
                    cell.customImageView.image = imageArray![index]
                }
                
                cell.customTextLabel.text = ( 0 == indexPath.row ) ? headerTitle : dataArray[indexPath.row-1]
            }
        }
        else
        {
            cell.customTextLabel.text = "取 消"
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if 0 == indexPath.section
        {
            var index : Int = 0
            if ( viewStyle == .DSCustomActionSheetStyleNormal || viewStyle == .DSCustomActionSheetStyleImage )
            {
                index = indexPath.row
            }
            else
            {
                index = indexPath.row - 1
            }
            if ( -1 == index )
            {
                print("【 DSActionSheet 】标题不能点击！")
                return
            }
            self.callback(index)
        }
        else if ( 1 == indexPath.section )
        {
            print("【 DSActionSheet 】你点击了取消按钮！")
            self.dismiss()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - UpdateFrame
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //这里因为转屏了要重新赋值
//        viewWidth = UIScreen.mainScreen().applicationFrame.size.width
//        
//        viewHeight = UIScreen.mainScreen().applicationFrame.size.height
        
        let tableViewHeight : CGFloat = min(viewHeight - 64.0, self.tableView.contentSize.height)
        
        tableView.frame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: tableViewHeight)
        
        self.frame = CGRect(x: 0.0, y: viewHeight - tableViewHeight, width: viewWidth, height: tableViewHeight)
    }
    
    //MARK: - Animation
    
    func fadeIn() {
        
        let tableViewHeight : CGFloat = min(viewHeight - 64.0, self.tableView.contentSize.height)

        tableView.frame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: tableViewHeight)
        
        frame = CGRect(x: 0.0, y: viewHeight, width: viewWidth, height: tableViewHeight)
        
        UIView.animateWithDuration(0.25) { 
            self.frame = CGRect(x: 0.0, y: self.viewHeight - tableViewHeight, width: self.viewWidth, height: tableViewHeight)
        }
    }
    
    func fadeOut() {
        UIView.animateWithDuration(0.25, animations: { 
            self.frame = CGRect(x: 0.0, y: self.viewHeight, width: self.viewWidth, height: CGRectGetHeight(self.frame))
            }) { (finished) in
                if finished
                {
                    self.overlayControl.removeFromSuperview()
                    for view in self.subviews {
                        view.removeFromSuperview()
                    }
                    self.removeFromSuperview()
                }
        }
    }
    
    func show() {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        keyWindow?.addSubview(overlayControl)
        keyWindow?.addSubview(self)
        self.fadeIn()
    }
    
    func dismiss() {
        print("【 DSActionSheet 】你触摸了背景隐藏！")
        self.fadeOut()
    }

    //MARK: - lazy
    lazy var tableView : UITableView = {
        let _tableView = UITableView(frame : CGRectZero , style: UITableViewStyle.Grouped)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.scrollEnabled = false
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        _tableView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        self.addSubview(_tableView)
        
        _tableView.registerNib(UINib.init(nibName: DSASCellIdentifier, bundle: nil), forCellReuseIdentifier: DSASCellIdentifier)
        
        let autoresizing : UIViewAutoresizing = [.FlexibleBottomMargin , .FlexibleLeftMargin , .FlexibleRightMargin , .FlexibleWidth]
        _tableView.autoresizingMask = autoresizing
        
        return _tableView
    }()
    
    lazy var overlayControl : UIControl = {
        
        var _overlayControl = UIControl(frame: UIScreen.mainScreen().bounds)
        
        _overlayControl.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)
        
        let autoresizing : UIViewAutoresizing = [.FlexibleBottomMargin , .FlexibleLeftMargin , .FlexibleRightMargin , .FlexibleWidth, .FlexibleHeight]
        _overlayControl.autoresizingMask = autoresizing
        
        _overlayControl.addTarget(self, action: #selector(DSActionSheet.dismiss), forControlEvents: .TouchUpInside)
        
        return _overlayControl
    }()
}
