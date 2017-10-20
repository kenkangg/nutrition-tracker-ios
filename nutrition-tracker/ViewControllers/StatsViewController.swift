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
    
    var values: [Int]?
    var dates: [(Int,Int)]?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addBackgroundParallax()
        
        if let calorieCount = self.defaults.value(forKey: "Calorie Count") {
            self.calorieCount = calorieCount as? Int
        } else {
            self.calorieCount = 0
        }
        
        setProperDateAndData()
    
        calorieLabel.text = String(describing: calorieCount!)
        
        saveToUserDefaults()
        // Do any additional setup after loading the view.
    }
    
    func saveToUserDefaults() {
        self.defaults.set(self.values!, forKey: "dailyCals")
        
        var months: [Int] = []
        var days: [Int] = []
        for i in 0 ... 6 {
            let (month, day) = self.dates![i]
            
            months.append(month)
            days.append(day)
        }

        self.defaults.set(months, forKey: "CalMonths")
        self.defaults.set(days, forKey: "CalDays")
    }
    
    func convertDatesToArray(months: [Int], days: [Int]) -> [(Int, Int)] {
        var dates: [(Int,Int)] = []
        for i in 0 ... 6 {
            dates.append((months[i], days[i]))
        }
        return dates
    }
    
    
    
    func updateLineChart() {
        var entries:[ChartDataEntry] = []
        for i in 0...6 {
            let (month,day) = self.dates![i]
            let formattedDate = Double(month) + Double(day) * 0.01

            if i == 6 {
                entries.append(ChartDataEntry(x: formattedDate, y: Double(self.calorieCount!)))
            } else {
                entries.append(ChartDataEntry(x: formattedDate, y: Double(self.values![i])))
            }
        }

        
        let dataset = LineChartDataSet(values: entries, label: "")
        
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
        
//        lineGraphView.xAxis.drawLabelsEnabled = false
        lineGraphView.leftAxis.drawLabelsEnabled = false
        lineGraphView.rightAxis.drawLabelsEnabled = false
        
        lineGraphView.animate(yAxisDuration: 1.5, easingOption: .easeInOutCubic)
        lineGraphView.legend.enabled = false
        lineGraphView.doubleTapToZoomEnabled = false
        lineGraphView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        
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

extension StatsViewController {
    func setProperDateAndData() {
        var oldValues: [Int]?
        var oldDates: [(Int,Int)]?
        
        if let vals = self.defaults.value(forKey: "dailyCals"), let mth = self.defaults.value(forKey: "CalMonths"), let dy = self.defaults.value(forKey: "CalDays") {
            oldValues = vals as? [Int]
            oldDates = convertDatesToArray(months: (mth as? [Int])!, days: (dy as? [Int])!)
        } else {
            oldValues = [0, 0, 0, 0, 0, 0, self.calorieCount!]
            oldDates = [(0,0), (0,0), (0,0), (0,0), (0,0), (0,0), (0,0)]
            print("WASSUP")
        }
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [Int]()
        var months = [Int]()
        for _ in 1 ... 7 {
            let day = cal.component(.day, from: date)
            let month = cal.component(.month, from: date)
            days.append(day)
            months.append(month)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        days.reverse()
        months.reverse()
        
        self.dates = []
        for i in 0 ... 6 {
            self.dates!.append((months[i],days[i]))
        }
        
        self.values = [0, 0, 0, 0, 0, 0, self.calorieCount!]
        
        var newDates:[(Int, Int)] = []
        var newValues:[Int] = []
        var last: (Int, Int)?
        for i in 0 ... 6 {
            if (self.dates?.contains(where: {$0 == oldDates![i]}))! {
                newDates.append(oldDates![i])
                newValues.append(oldValues![i])
                last = oldDates![i]
            }
        }
        print("WHAT")
        if let val = last {
            if let index = self.dates!.index(where: {$0 == val}) {
                if index != 6 {
                    for i in index + 1 ... 6 {
                        newDates.append(self.dates![i])
                        newValues.append(self.values![i])
                    }
                    self.calorieCount! = 0
                    defaults.set(self.calorieCount!, forKey: "Calorie Count")
                    newValues[6] = self.calorieCount!
                } else {
                    newValues[6] = self.calorieCount!
                }
                
                self.values = newValues
                self.dates = newDates
            }
        } else {
        }
    }
    
    func moveValsBackADay(vals: [Int]) {
//        for x in
    }
}
