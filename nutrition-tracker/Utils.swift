//
//  Utils.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/18/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    static func updateUserData(view: UIViewController) {
        // Save current calorie count from StatsViewController to UserDefaults
        // Must be used in a subview of main ViewController
        let parent = view.parent as! ViewController
        let count = parent.VStats?.calorieCount!
        
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: "Calorie Count")
    }
}
