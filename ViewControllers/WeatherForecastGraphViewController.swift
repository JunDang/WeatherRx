//
//  WeatherForecastGraphViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-21.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography
import Charts
struct Hourly {
    var time: Int?
    var iconName: String?
    var temperature: Double?
}
class WeatherForecastGraphViewController: UIViewController {
    
    private let hourlyGraphView = UIView(frame: CGRect.zero)
    private let dailyGraphView = UIView(frame: CGRect.zero)
    private let hourlyLbl = UILabel()
    private let dailyLbl = UILabel()
    private let hourlyChartView = LineChartView(frame:CGRect.zero)
    private let dailyChartView = LineChartView(frame:CGRect.zero)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        setStyle()
        render()
    }
    override open func viewWillAppear(_ animated: Bool) {
       hourlyChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}

extension WeatherForecastGraphViewController {
    func setup() {
        hourlyGraphView.addSubview(hourlyChartView)
        view.addSubview(hourlyGraphView)
        view.addSubview(dailyGraphView)
        view.addSubview(hourlyLbl)
        view.addSubview(dailyLbl)
    }
}

extension WeatherForecastGraphViewController {
    func layoutView() {
        constrain(hourlyLbl) {
            $0.top == $0.superview!.top + 10
            $0.left == $0.superview!.left + 10
        }
        constrain(hourlyGraphView, hourlyLbl ) {
            $0.height == $0.superview!.height/2 - 50
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
            $0.top == $1.bottom
        }
        constrain(hourlyChartView) {
            $0.top == $0.superview!.top - 10
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
            $0.bottom == $0.superview!.bottom + 10
        }
        constrain(dailyLbl, hourlyGraphView) {
            $0.top == $1.bottom + 30
            $0.left == $0.superview!.left + 10
        }
        constrain(dailyGraphView, dailyLbl ) {
            $0.height == $0.superview!.height/2 - 50
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
            $0.top == $1.bottom
        }
    }
}

extension WeatherForecastGraphViewController {
    func setStyle() {
        view.backgroundColor = UIColor.clear
        hourlyGraphView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dailyGraphView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        hourlyLbl.backgroundColor = UIColor.clear
        hourlyLbl.textColor = UIColor.white
        hourlyLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        hourlyLbl.sizeToFit()
        dailyLbl.backgroundColor = UIColor.clear
        dailyLbl.textColor = UIColor.white
        dailyLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        dailyLbl.sizeToFit()
        
    }
}

extension WeatherForecastGraphViewController {
    func render() {
       hourlyLbl.text = "Hourly Forecast Trend"
       dailyLbl.text = "Daily Forecast Trend"
    }
   func drawHourlyLine(with weatherForecastModel: WeatherForecastModel) {
        print("weatherForecastModel: \(weatherForecastModel)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let hourlyWeatherModel = weatherForecastModel.hourly?.hourlyWeatherModel
        let unitChange =  UserDefaults.standard.string(forKey: "UnitChange")
        var hours: [String] = []
        var temperature: Double = 0.0
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<hourlyWeatherModel!.count {
            //let hourTime = Double(hourlyWeatherModel![i].time)
            let hour = dateFormatter.string(from: hourlyWeatherModel![i].timeDate!)
            //print("hourString: \(hourString)")
            if unitChange == "convertToImperial" {
               temperature = hourlyWeatherModel![i].temperature
            } else {
               temperature = hourlyWeatherModel![i].temperature.toCelcius()
            }
            let icon = UIImage(named: hourlyWeatherModel![i].icon)
            let value = ChartDataEntry(x: Double(i), y: temperature, icon: icon)
            lineChartEntry.append(value)
            hours.append(hour)
        }
        let hourlyLine = LineChartDataSet(values: lineChartEntry, label: "Hours")
    
        print("hourlyLine: \(hourlyLine)")
        
       /* hourlyLine.circleRadius = 5.0
        hourlyLine.circleColors = [NSUIColor.red]
        //hourlyLine.setCircleColor(UIColor.red)
        hourlyLine.lineWidth = 0.8
        hourlyLine.colors = [NSUIColor.red]
        hourlyLine.drawCircleHoleEnabled = true
        hourlyLine.circleHoleRadius = 4.0
        hourlyLine.circleHoleColor = UIColor.black.withAlphaComponent(0.6)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.locale = Locale.current
        hourlyLine.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)*/
        hourlyLine.axisDependency = .left // Line will correlate with left axis values
        hourlyLine.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        hourlyLine.setCircleColor(UIColor.red) // our circle will be dark red
        hourlyLine.lineWidth = 2.0
        hourlyLine.circleRadius = 6.0 // the radius of the node circle
        hourlyLine.fillAlpha = 65 / 255.0
        hourlyLine.fillColor = UIColor.black.withAlphaComponent(0.6)
        hourlyLine.highlightColor = UIColor.black.withAlphaComponent(0.6)
        hourlyLine.drawCircleHoleEnabled = true
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.locale = Locale.current
        hourlyLine.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
    
    
        // x axis setup
        let xAxis = hourlyChartView.xAxis
        xAxis.labelCount = 8
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = UIColor.white
        xAxis.labelTextColor = UIColor.white
        xAxis.labelFont = UIFont(name: "Avenir", size: 10)!
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values:hours)
        
        // y axis setup
        let leftAxis = hourlyChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelTextColor = UIColor.white
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisLineColor = UIColor.white
        leftAxis.labelFont = UIFont(name: "Avenir", size: 10)!
    
    
    
        hourlyChartView.rightAxis.enabled = false
        hourlyChartView.legend.enabled = true
        hourlyChartView.legend.textColor = UIColor.white
        hourlyChartView.legend.formSize = CGFloat(6.0)
        
        let lineChartData = LineChartData()
        
        lineChartData.addDataSet(hourlyLine)
        lineChartData.setValueFont(UIFont(name: "Avenir", size: 8))
        lineChartData.setDrawValues(true)
        lineChartData.setValueTextColor(UIColor.white)
        hourlyChartView.drawGridBackgroundEnabled = false
        hourlyChartView.data = lineChartData
        print("hourlyChartView.data: \(hourlyChartView.data)")
    
    
    
        
        hourlyChartView.notifyDataSetChanged()
        
    }
    func renderAxisLabels(context: CGContext) {
        
    }
}

    
    /*func drawHourlyLine(with hourlyForecasts: [Hourly]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
               //let hours = dateFormatter.string(from: hourlyWeatherModel.timeDate!)
        // let temperatures = hourlyForecastData.temperature
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<hourlyForecasts.count {
            let hourTime = Double(hourlyForecasts[i].time!)
            //let hourString = dateFormatter.string(from: hourlyForecasts[i].timeDate!)
            //print("hourString: \(hourString)")
            let temperature = hourlyForecasts[i].temperature
            let icon = UIImage(named: hourlyForecasts[i].iconName!)
            let value = ChartDataEntry(x: hourTime, y: temperature!, icon: icon)
            lineChartEntry.append(value)
        }
        let hourlyLine = LineChartDataSet(values: lineChartEntry, label: "Hours")
        print("hourlyLine: \(hourlyLine)")
        
        hourlyLine.circleRadius = 2.0
        
        /* // x axis setup
         let xAxis = hourlyChartView.xAxis
         xAxis.labelPosition = .bottom
         xAxis.axisLineColor = UIColor.white
         xAxis.labelTextColor = UIColor.white
         xAxis.labelFont = UIFont(name: "Avenir", size: 8)!
         xAxis.labelPosition = .bottom
         xAxis.drawGridLinesEnabled = false
         
         // y axis setup
         let leftAxis = hourlyChartView.leftAxis
         leftAxis.drawGridLinesEnabled = false
         leftAxis.labelTextColor = UIColor.white
         leftAxis.labelPosition = .outsideChart
         leftAxis.spaceTop = 0.15;
         leftAxis.axisLineColor = UIColor.white
         leftAxis.labelFont = UIFont(name: "Avenir", size: 8)!
         
         hourlyChartView.rightAxis.enabled = false
         hourlyChartView.legend.enabled = true
         hourlyChartView.legend.textColor = UIColor.white
         hourlyChartView.legend.formSize = CGFloat(6.0)*/
        
        let lineChartData = LineChartData()
        lineChartData.addDataSet(hourlyLine)
        lineChartData.setValueFont(UIFont(name: "Avenir", size: 8))
        lineChartData.setDrawValues(true)
        lineChartData.setValueTextColor(UIColor.white)
        hourlyChartView.drawGridBackgroundEnabled = false
        hourlyChartView.data = lineChartData
        hourlyChartView.chartDescription?.text = "My awesome chart"
        print("hourlyChartView.data: \(hourlyChartView.data)")

  }
}*/
