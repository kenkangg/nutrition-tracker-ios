//
//  ViewController.swift
//  calorie-tracker
//
//  Created by Kenny Kang on 10/16/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var VCamera: CameraViewController?
    var VFood: FoodViewController?
    var VStats: StatsViewController?

    @IBOutlet weak var swipeView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let VLeft: LeftViewController = LeftViewController(nibName: "LeftViewController", bundle: nil)
//        let VCenter: CenterViewController = CenterViewController(nibName: "CenterViewController", bundle: nil)
        
        VStats = self.storyboard?.instantiateViewController(withIdentifier: "statsView") as? StatsViewController
        VCamera = self.storyboard?.instantiateViewController(withIdentifier: "cameraView") as? CameraViewController
        VFood = self.storyboard?.instantiateViewController(withIdentifier: "foodView") as? FoodViewController
        
        self.addChildViewController(VCamera!)
        self.swipeView.insertSubview((VCamera?.view)!, at: 0)
        VCamera?.didMove(toParentViewController: self)
        
        self.addChildViewController(VFood!)
        self.swipeView.insertSubview((VFood?.view)!, at: 0)
        VFood?.didMove(toParentViewController: self)
        
        self.addChildViewController(VStats!)
        self.swipeView.insertSubview((VStats?.view)!, at: 0)
        VStats?.didMove(toParentViewController: self)
        
        var foodFrame: CGRect = VFood!.view.frame
        foodFrame.origin.x = 2 * self.view.frame.width
        VFood?.view.frame  = foodFrame
        
        var cameraFrame: CGRect = VCamera!.view.frame
        cameraFrame.origin.x = self.view.frame.width
        VCamera?.view.frame  = cameraFrame
        
        self.swipeView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        self.swipeView.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

