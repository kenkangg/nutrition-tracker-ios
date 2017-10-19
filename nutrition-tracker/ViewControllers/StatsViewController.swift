//
//  StatsViewController.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/18/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController {
    
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var statsBG: UIImageView!
    @IBOutlet weak var lineGraphView: LineChartView!

    var calorieCount: Int?
    var chartMade:Bool = false
    
    var values: Queue<Int>?
    var dates: Queue<(Int, Int)>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let values = defaults.value(forKey: "dailyCals"), let dates = defaults.value(forKey: "CalDates") {
            self.values = values as? Queue<Int>
            self.dates = dates as? Queue<(Int, Int)>
        } else {
            self.values = Queue<Int>()
            self.dates = Queue<(Int, Int)>()
        }
        
        
        
        
        var values = Queue<Int>()
        var dates = Queue<(Int, Int)>()
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        let day = cal.component(.day, from: date)
        let month = cal.component(.month, from: date)
        let currentDate = (month: month, day: day)
        
//        if let today = defaults.set(currentDate, forKey: "previous date") {
//
//        }
//
//        var days = [Int]()
//        for _ in 1 ... 7 {
//            let day = cal.component(.day, from: date)
//            let month = cal.component(.month, from: date)
//            days.append(day)
//            date = cal.date(byAdding: .day, value: -1, to: date)!
//        }
//        print(days)
        
        
        addBackgroundParallax()
        
        
        if let calorieCount = defaults.value(forKey: "Calorie Count") {
            self.calorieCount = calorieCount as? Int
        } else {
            self.calorieCount = 0
        }
    
        calorieLabel.text = String(describing: calorieCount!)

        // Do any additional setup after loading the view.
    }
    
    func updateLineChart() {
//        var entries = []
//        for x in self.values {
//
//        }
        let entry1 = ChartDataEntry(x: (10.05), y: 3000)
        let entry2 = ChartDataEntry(x: (10.06), y: 2800)
        let entry3 = ChartDataEntry(x: (10.07), y: Double(self.calorieCount!))
        
        let dataset = LineChartDataSet(values: [entry1, entry2, entry3], label: "")
        
        let gradientColors = [UIColor.orange.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.5, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        dataset.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        dataset.drawFilledEnabled = true
        
        let data = LineChartData(dataSets: [dataset])
        
        lineGraphView.data = data
        lineGraphView.chartDescription?.text = ""
        
        
        lineGraphView.xAxis.drawGridLinesEnabled = false
        lineGraphView.xAxis.drawAxisLineEnabled = false

        lineGraphView.leftAxis.drawGridLinesEnabled = false
        lineGraphView.rightAxis.drawGridLinesEnabled = false
        lineGraphView.leftAxis.drawAxisLineEnabled = false
        lineGraphView.rightAxis.drawAxisLineEnabled = false
        
        lineGraphView.xAxis.drawLabelsEnabled = false
        lineGraphView.leftAxis.drawLabelsEnabled = false
        lineGraphView.rightAxis.drawLabelsEnabled = false
        
        lineGraphView.animate(yAxisDuration: 1.5, easingOption: .easeInOutCubic)
        lineGraphView.legend.enabled = false
        // Color
        dataset.colors = ChartColorTemplates.pastel()
        
        // Refresh chart with new data
        lineGraphView.notifyDataSetChanged()
    }
    
    func addBackgroundParallax() {
        
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
