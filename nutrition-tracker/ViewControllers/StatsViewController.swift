//
//  StatsViewController.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/18/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var statsBG: UIImageView!
    var calorieCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        
        statsBG.addMotionEffect(motionEffectGroup)
        
        
        
        let defaults = UserDefaults.standard
        if let calorieCount = defaults.value(forKey: "Calorie Count") {
            self.calorieCount = calorieCount as? Int
        } else {
            self.calorieCount = 0
        }
    
        calorieLabel.text = String(describing: calorieCount!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetCalorieCount(_ sender: Any) {
        confirmCalorieAdd()
    }
    
    func confirmCalorieAdd() {
        
        let predictAlert = UIAlertController(title: "Reset", message: "Are you sure you want to reset your count?" , preferredStyle: UIAlertControllerStyle.alert)
        
        predictAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.calorieCount = 0
            self.calorieLabel.text = String(describing: self.calorieCount!)
        }))
        
        predictAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        
        
        present(predictAlert, animated: true, completion: nil)
        
    }
    

}
