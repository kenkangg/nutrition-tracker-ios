//
//  ViewController.swift
//  calorie-tracker
//
//  Created by Kenny Kang on 10/16/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var swipeView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let VLeft: LeftViewController = LeftViewController(nibName: "LeftViewController", bundle: nil)
        let VCenter: CenterViewController = CenterViewController(nibName: "CenterViewController", bundle: nil)
        
        self.addChildViewController(VLeft)
        self.swipeView.insertSubview(VLeft.view, at: 0)
        VLeft.didMove(toParentViewController: self)
        
        self.addChildViewController(VCenter)
        self.swipeView.insertSubview(VCenter.view, at: 0)
        VCenter.didMove(toParentViewController: self)
        
        var CenterFrame: CGRect = VCenter.view.frame
        CenterFrame.origin.x = self.view.frame.width
        VCenter.view.frame  = CenterFrame
        
        self.swipeView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

