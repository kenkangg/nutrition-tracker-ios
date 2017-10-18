//
//  CenterViewController.swift
//  calorie-tracker
//
//  Created by Kenny Kang on 10/16/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit

class CenterViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        getData()
    }
    
    func getData() {
    

        
        var url = URLComponents(string: "https://trackapi.nutritionix.com/v2/search/instant")
        url?.queryItems = [URLQueryItem(name: "query", value: "apple")]
        
        var request = URLRequest(url: url!.url!)
        request.addValue("9606db03", forHTTPHeaderField: "x-app-id")
        request.addValue("716b72f21cc9f14fcf3cd5bbc0e72b1d", forHTTPHeaderField: "x-app-key")
        request.addValue("runscope/0.1", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                var parsedResult:AnyObject!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                } catch {
                    
                }
                print(parsedResult)
            }
            
        }
        task.resume()
    

    }

}
