//
//  Food.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/17/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import Foundation
import UIKit

class Food {
    
    var name: String?
    var calories: Int?
    var photo: UIImage?

    init(json: [String: AnyObject]) {
        
        let name = json["food_name"] as? String ?? ""
        let calories = json["nf_calories"] as? Int ?? 0
        let photo = json["photo"] as? [String: AnyObject] ?? ["": "" as AnyObject]

        self.name = name
        self.calories = calories
        let url = photo["thumb"] as! String
        

        do {
            try self.photo = UIImage(data: Data(contentsOf: URL(string: url)!)) ?? UIImage()
        } catch {
            
        }
    }

    
}




