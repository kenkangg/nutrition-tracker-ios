//
//  foodViewController.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/17/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var foodArray: Array<Food>?
    
    var task: URLSessionDataTask?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.backgroundView = imageView
        
        
        
        
        foodArray = Array<Food>()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.backgroundView = imageView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* SearchBarDelegate Method */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            foodArray = Array<Food>()
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        
        /*
         Uncomment for autocomplete search.
         WARNING: This abuses NutritionIX's free 1000 request limit for free use of their API
         */
//        if let task = self.task {
//            task.cancel()
//            if searchText == "" {
//                return
//            }
//            getData(foodChoice: searchText, completion: nil)
//        } else {
//            getData(foodChoice: searchText, completion: nil)
//        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        lookUpFood(foodChoice: searchBar.text!, completion: nil)
        self.searchBar.endEditing(true)
    }
    
    /* TableViewDelegate Methods */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if indexPath.row > (foodArray?.count)! {
            print("Problem")
        }
        cell?.textLabel?.text = foodArray![indexPath.row].name
        cell?.detailTextLabel?.text = "Calories: " + String(describing: foodArray![indexPath.row].calories!)
        cell?.imageView?.image = foodArray![indexPath.row].photo
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        confirmCalorieAdd(food: foodArray![indexPath.row])

    }

    
    func lookUpFood(foodChoice: String, completion: (() -> Void)?) {
        
        var url = URLComponents(string: "https://trackapi.nutritionix.com/v2/search/instant")
        url?.queryItems = [URLQueryItem(name: "query", value: foodChoice)]
        
        var request = URLRequest(url: url!.url!)
        request.addValue("9606db03", forHTTPHeaderField: "x-app-id")
        request.addValue("716b72f21cc9f14fcf3cd5bbc0e72b1d", forHTTPHeaderField: "x-app-key")
        request.addValue("runscope/0.1", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET"
        
        
        self.task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                var parsedResult:[String: Any]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                } catch {
                    
                }
                self.processJSON(json: parsedResult, completion: completion)
                
            }
            
        }
        self.task?.resume()
        
        
    }
    
    func processJSON(json: [String: Any], completion: (() -> Void)?) {
        if let data = json["branded"] as? Array<[String:AnyObject]> {
            var newData: Array<Food>
            newData = Array<Food>()
            var count = 10
            for foodData in data {
                if count <= 0 {
                    break
                }
                let food = Food(json: foodData)
                newData.append(food)
                count = count - 1
                
            }
            self.foodArray = newData
            completion?()
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    func confirmCalorieAdd(food: Food) {
        let parent = self.parent as! ViewController
        let calories = String(describing: food.calories!)
        let name = String(describing: food.name!)
        
        let predictAlert = UIAlertController(title: name.capitalized, message: "Add " + calories + " calories?" , preferredStyle: UIAlertControllerStyle.alert)
        
        predictAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let statsController = parent.VStats
            statsController?.calorieCount! += food.calories!
            statsController?.calorieLabel.text = String(describing: (statsController?.calorieCount!)!)
            Utils.updateUserData(view: self)
        }))
        
        predictAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        
        present(predictAlert, animated: true, completion: nil)
        
    }
    
    
}

