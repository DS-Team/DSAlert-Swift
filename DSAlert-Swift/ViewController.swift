//
//  ViewController.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/8/31.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import UIKit

let titleMsg1 = "欢迎使用 iPhone SE，迄今最高性能的 4 英寸 iPhone。在打造这款手机时，我们在深得人心的 4 英寸设计基础上，从里到外重新构想。它所采用的 A9 芯片，正是在 iPhone 6s 上使用的先进芯片。1200 万像素的摄像头能拍出令人叹为观止的精彩照片和 4K 视频，而 Live Photos 则会让你的照片栩栩如生。这一切，成就了一款外形小巧却异常强大的 iPhone。"

let titleMsg2 = "对于 MacBook，我们给自己设定了一个几乎不可能实现的目标：在有史以来最为轻盈纤薄的 Mac 笔记本电脑上，打造全尺寸的使用体验。这就要求每个元素都必须重新构想，不仅令其更为纤薄轻巧，还要更加出色。最终我们带来的，不仅是一部新款的笔记本电脑，更是一种对笔记本电脑的前瞻性思考。现在，有了第六代 Intel 处理器、提升的图形处理性能、高速闪存和最长可达 10 小时的电池使用时间*，MacBook 的强大更进一步。"


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    var chooseBtn = UIButton?()
    var titleLabel = UILabel?()
    var alertView5 = DSAlert()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DSAlert";
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return demoDataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tempArray : Array = demoDataArray[section];
        return tempArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (0 == section) ? 40 : 20;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.numberOfLines = 0;
        cell.accessoryType = (0 == indexPath.section) ? UITableViewCellAccessoryType.DisclosureIndicator: UITableViewCellAccessoryType.None
        cell.selectionStyle = (0 == indexPath.section) ? UITableViewCellSelectionStyle.Default : UITableViewCellSelectionStyle.None
        
        let tempArray = demoDataArray[indexPath.section] 
        cell.textLabel?.text = tempArray[indexPath.row]
        return cell;
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let headerTitle = UILabel()
        headerTitle.font = UIFont.systemFontOfSize(13)
        headerTitle.textColor = UIColor.redColor()
        headerTitle.numberOfLines = 0;
        headerView.addSubview(headerTitle)
        
        if ( 0 == section)
        {
            headerTitle.frame = CGRectMake(20, 0, SCREENWIDTH - 40, 40);
            headerTitle.text = "alert 的几种日常用法，高斯模糊、炫酷动画，应有尽有！";
        }
        else if (1 == section)
        {
            headerTitle.frame = CGRectMake(20, 0, SCREENWIDTH - 40, 20);
            headerTitle.text = "测试 ActionSheet，开发 ing 慎点！";
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if 0 == indexPath.section
        {
            self.showAlert(indexPath.row)
        }else if 1 == indexPath.section
        {
            self.showActionSheet(indexPath.row)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - ActionSheet点击事件
    func showActionSheet(index : Int) {
        switch index {
        case 0:
            DSActionSheet.ds_showActionSheetWithStyle(style: .DSCustomActionSheetStyleNormal,
                                                      contentArray: ["测试1","测试2","测试3"],
                                                      imageArray: nil,
                                                      redIndex: 1,
                                                      title: nil)
            { (index) in
                print("你点击了第 \(index) 行！")
            }
        case 1:
            DSActionSheet.ds_showActionSheetWithStyle(style: .DSCustomActionSheetStyleTitle,
                                                      contentArray: ["测试1","测试2","测试3"],
                                                      imageArray: nil,
                                                      redIndex: 1,
                                                      title: "测试带标题的ActionSheet增加长度~~~~~~~~~~~~~~~~~~~~~~~~~")
            { (index) in
                print("你点击了第 \(index) 行！")
            }
        case 2:
            DSActionSheet.ds_showActionSheetWithStyle(style: .DSCustomActionSheetStyleImageAndTitle,
                                                      contentArray: ["测试1增加长度~~~~~~~~~~~~~~~~~~~~~~~~~","测试2","测试3"],
                                                      imageArray: [UIImage.init(named: "123.png")!,UIImage.init(named: "背景.jpg")!,UIImage.init(named: "美女.jpg")!],
                                                      redIndex: 1,
                                                      title: "测试带标题的ActionSheet增加长度~~~~~~~~~~~~~~~~~~~~~~~~~!!")
            { (index) in
                print("你点击了第 \(index) 行！")
            }
        default:
            break
        }
    }
    
    //MARK: - Alert点击事件
    func showAlert(index : Int) {
        switch (index) {
        case 0:
            self.alert1()
        case 1:
            self.alert2()
        case 2:
            self.alert3()
        case 3:
            self.alert4()
        case 4:
            self.alert5()
        default:
            break
        }
    }
    
    func alert1() {
        
        var duration : NSTimeInterval = 0.0
        
        
        DSAlert.ds_showAlertWithTitle(title: "温馨提示：", message: titleMsg1, image: nil, buttonTitles: ["取消","确定"], configuration: { (temp) in
            //        temp.bgColor       = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.3];
            /*! 开启边缘触摸隐藏alertView */
            temp.isTouchEdgeHide = true
            /*! 添加高斯模糊的样式 */
            temp.blurEffectStyle = .DSAlertBlurEffectStyleLight
            /*! 开启动画 */
            //        temp.isShowAnimate   = true;
            //        /*! 进出场动画样式 默认为：DSAlertBlurEffectStyleNone */
            duration = temp.animationDuration
            }) { (index) in
                if index == 0
                {
                    print("点击了取消按钮！")
                    /*! 隐藏alert */
                    //            [weakSelf.alertView1 ds_dismissAlertView];
                }
                else if (index == 1)
                {
                    print("点击了确定按钮！");
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
                        let vc2 : ViewController2 = ViewController2()
                        vc2.title = "alert1";
                        self.navigationController?.pushViewController(vc2, animated: true)
                    }
                }
        }
    }
    
    func alert2() {
        /*! 2、自定义按钮颜色 */
        let alertView : DSAlert = DSAlert.ds_showTitle(title: "博爱温馨提示：", message: titleMsg2, image: nil, buttonTitles: ["取消", "跳转VC2"])
        
        alertView.buttonTitleColor = UIColor.orangeColor();
        alertView.bgColor = UIColor(red: 1.0, green: 1.0, blue: 0, alpha: 0.3)
        
        /*! 是否开启进出场动画 默认：false，如果 true ，并且同步设置进出场动画枚举为默认值：1 */
        alertView.showAnimate = true
        
        /*! 显示alert */
        alertView.ds_showAlertView()

        alertView.buttonActionBlock = { (index) -> Void in
            if index == 0
            {
                print("点击了取消按钮！")
                /*! 隐藏alert */
                //            [weakSelf.alertView1 ds_dismissAlertView];
            }
            else if (index == 1)
            {
                print("点击了确定按钮！");
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(alertView.animationDuration * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
                    let vc2 : ViewController2 = ViewController2()
                    vc2.title = "alert2";
                    self.navigationController?.pushViewController(vc2, animated: true)
                }
            }
        }
    }
    
    func alert3() {
        
        /*! 3、自定义背景图片 */
        let alertView : DSAlert = DSAlert.ds_showTitle(title: "博爱温馨提示：", message: titleMsg1, image: nil, buttonTitles: ["取消", "确定"])
        
        alertView.buttonTitleColor = UIColor.orangeColor()
        alertView.bgImageName = "背景.jpg"
        
        /*! 是否开启进出场动画 默认：false，如果 true ，并且同步设置进出场动画枚举为默认值：1 */
//        alertView.showAnimate = true
        
        /*! 没有开启动画，直接进出场动画样式，默认开启动画 */
        alertView.animatingStyle  = .DSAlertAnimatingStyleShake
        
        /*! 显示alert */
        alertView.ds_showAlertView()
        
        alertView.buttonActionBlock = { (index) -> Void in
            if index == 0
            {
                print("点击了取消按钮！")
                /*! 隐藏alert */
                //            [weakSelf.alertView1 ds_dismissAlertView];
            }
            else if (index == 1)
            {
                print("点击了确定按钮！");
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(alertView.animationDuration * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
                    let vc2 : ViewController2 = ViewController2()
                    vc2.title = "alert3";
                    self.navigationController?.pushViewController(vc2, animated: true)
                }
            }
        }
    }
    
    func alert4() {
        
        /*! 4、内置图片和文字，可滑动查看 */
        let alertView : DSAlert = DSAlert.ds_showTitle(title: "博爱温馨提示：", message: titleMsg1, image: UIImage(named: "美女.jpg"), buttonTitles: ["取消", "跳转VC2"])
        /*! 自定义按钮文字颜色 */
        alertView.buttonTitleColor = UIColor.orangeColor()
        /*! 自定义alert的背景图片 */
        alertView.bgImageName = "背景.jpg"
        /*! 是否开启进出场动画 */
        alertView.showAnimate = true
        /*! 显示alert */
        alertView.ds_showAlertView()
        
        alertView.buttonActionBlock = { (index) -> Void in
            if index == 0
            {
                print("点击了取消按钮！")
                /*! 隐藏alert */
                //            [weakSelf.alertView1 ds_dismissAlertView];
            }
            else if (index == 1)
            {
                print("点击了确定按钮！");
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(alertView.animationDuration * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
                    let vc2 : ViewController2 = ViewController2()
                    vc2.title = "alert4";
                    self.navigationController?.pushViewController(vc2, animated: true)
                }
            }
        }
    }
    
    func alert5() {
        
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        let view1 = UIView()
        view1.frame = CGRect(x: 30, y: 100, width: screenWidth - 60, height: 200)
        print(view1.frame)
        view1.backgroundColor = UIColor.yellowColor()
        view1.layer.masksToBounds = true
        view1.layer.cornerRadius = 10.0
        
        if titleLabel == nil {
            titleLabel = UILabel(frame : CGRect(x: 0, y: 0, width: CGRectGetWidth(view1.frame), height: 40))
            titleLabel?.text = "测试title"
            titleLabel?.textAlignment = .Center
            titleLabel?.font = UIFont.systemFontOfSize(18)
            titleLabel?.backgroundColor = UIColor.greenColor()
            titleLabel?.autoresizingMask = UIViewAutoresizing([.FlexibleWidth])
            view1.addSubview(titleLabel!)
        }
        
        
        if chooseBtn == nil {
            chooseBtn = UIButton(frame: CGRect(x: 0, y: CGRectGetHeight(view1.frame) - 40, width: CGRectGetWidth(view1.frame), height: 40))
            chooseBtn?.setTitle("取消", forState: .Normal)
            chooseBtn?.backgroundColor = UIColor.redColor()
            chooseBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            chooseBtn?.addTarget(self, action: #selector(self.cancleButtonAction(_:)), forControlEvents: .TouchUpInside)
            chooseBtn?.autoresizingMask = UIViewAutoresizing([.FlexibleWidth])
            view1.addSubview(chooseBtn!)
        }
        
        
        alertView5 = DSAlert.initWithCustomView(view1)
        alertView5.showAnimate = true
        alertView5.ds_showAlertView()
    }
    
    func cancleButtonAction(sender: UIButton) {
        print("点击了取消按钮！")
        alertView5.ds_dismissAlertView()
        titleLabel = nil
        chooseBtn = nil
    }
    
    //MARK: - lazy
    lazy var demoDataArray:[[String]]! = {
        
        var result = [[String]]()
        
        result.append(["1、类似系统alert【加边缘手势消失】",
            "2、自定义按钮颜色",
            "3、自定义背景图片",
            "4、内置图片和文字，可滑动查看",
            "5、完全自定义alert"])
        
        result.append(["6、actionsheet",
            "7、actionsheet带标题",
            "8、actionsheet带标题带图片"])
        
        result.append(["DSAlert特点：\n1、手势触摸隐藏开关，可随时开关\n2、可以自定义背景图片、背景颜色、按钮颜色\n3、可以添加文字和图片，且可以滑动查看！\n4、横竖屏适配完美\n5、有各种炫酷动画展示你的alert\n6、理论完全兼容现有所有 iOS 系统版本"])
        
        return result
    }()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

