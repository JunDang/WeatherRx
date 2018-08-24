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

class WeatherForecastGraphViewController: UIViewController {
    
    private let hourlyGraphView = UIView(frame: CGRect.zero)
    private let dailyGraphView = UIView(frame: CGRect.zero)
    private let hourlyLbl = UILabel()
    private let dailyLbl = UILabel()
    private let hourlyChartView = LineChartView(frame:CGRect.zero)
    private let dailyChartView = LineChartView(frame:CGRect.zero)
    private let hourlyUnitLbl = UILabel()
    private let dailyUnitLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        setStyle()
        render()
    }
    override open func viewWillAppear(_ animated: Bool) {
       hourlyChartView.animate(xAxisDuration: 0.6, yAxisDuration: 0.6)
    }
}

extension WeatherForecastGraphViewController {
    func setup() {
        hourlyChartView.addSubview(hourlyUnitLbl)
        hourlyGraphView.addSubview(hourlyChartView)
        view.addSubview(hourlyGraphView)
        dailyChartView.addSubview(dailyUnitLbl)
        dailyGraphView.addSubview(dailyChartView)
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
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $1.bottom
        }
        constrain(hourlyUnitLbl) {
            $0.centerY == $0.superview!.centerY
            $0.left == $0.superview!.left - 15
        }
        constrain(hourlyChartView) {
            $0.top == $0.superview!.top - 10
            $0.left == $0.superview!.left + 25
            $0.right == $0.superview!.right
            $0.bottom == $0.superview!.bottom + 10
        }
        constrain(dailyLbl, hourlyGraphView) {
            $0.top == $1.bottom + 30
            $0.left == $0.superview!.left + 10
        }
        constrain(dailyUnitLbl) {
            $0.centerY == $0.superview!.centerY
            $0.left == $0.superview!.left - 15
        }
        constrain(dailyChartView) {
            $0.top == $0.superview!.top - 10
            $0.left == $0.superview!.left + 25
            $0.right == $0.superview!.right
            $0.bottom == $0.superview!.bottom + 10
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
        hourlyUnitLbl.backgroundColor = UIColor.clear
        hourlyUnitLbl.textColor = UIColor.white
        hourlyUnitLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        hourlyUnitLbl.textAlignment = .left
        hourlyUnitLbl.sizeToFit()
        dailyUnitLbl.backgroundColor = UIColor.clear
        dailyUnitLbl.textColor = UIColor.white
        dailyUnitLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        dailyUnitLbl.textAlignment = .left
        dailyUnitLbl.sizeToFit()
        //unitLbl.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
    }
}

extension WeatherForecastGraphViewController {
    func render() {
       hourlyLbl.text = "Hourly Forecast Trend"
       dailyLbl.text = "Daily Forecast Trend"
    }
   func drawHourlyLine(with weatherForecastModel: WeatherForecastModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let hourlyWeatherModel = weatherForecastModel.hourly?.hourlyWeatherModel
        let unitChange =  UserDefaults.standard.string(forKey: "UnitChange")
        var hours: [String] = []
        var temperature: Double = 0.0
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<hourlyWeatherModel!.count {
             let hour = dateFormatter.string(from: hourlyWeatherModel![i].timeDate!)
            //print("hourString: \(hourString)")
            
            if unitChange == "convertToImperial" {
               temperature = hourlyWeatherModel![i].temperature
               hourlyUnitLbl.text = "\u{00B0}" + "F"
            } else {
               temperature = hourlyWeatherModel![i].temperature.toCelcius()
               hourlyUnitLbl.text = "\u{00B0}" + "C"
            }
            let iconName = WeatherIcon.iconMap[hourlyWeatherModel![i].icon]
            // print("hourlyIconName: " + "\(iconName)")
            let iconImage = UIImage(named: "\(String(describing: iconName!))")
            let value = ChartDataEntry(x: Double(i), y: temperature, icon: iconImage)
            lineChartEntry.append(value)
            hours.append(hour)
        }
        let hourlyLine = LineChartDataSet(values: lineChartEntry, label: "Hours")
        hourlyLine.axisDependency = .left 
        hourlyLine.setColor(UIColor.red.withAlphaComponent(0.5))
        //hourlyLine.setCircleColor(UIColor.red)
        hourlyLine.lineWidth = 2.0
        hourlyLine.drawCirclesEnabled = false
        hourlyLine.drawCircleHoleEnabled = false
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
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: numberFormatter)
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
        hourlyChartView.notifyDataSetChanged()
        hourlyChartView.chartDescription?.text = "Hourly Forecast Trend"
        hourlyChartView.chartDescription?.textColor = UIColor.white
    }
    
    func drawDailyLines(with weatherForecastModel: WeatherForecastModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dailyWeatherModel = weatherForecastModel.daily?.dailyWeatherModel
        let unitChange =  UserDefaults.standard.string(forKey: "UnitChange")
        var days: [String] = []
        var temperatureMax: Double = 0.0
        var temperatureMin: Double = 0.0
        var lineChartEntryMax = [ChartDataEntry]()
        var lineChartEntryMin = [ChartDataEntry]()
        for i in 0..<dailyWeatherModel!.count {
            let day = dateFormatter.string(from: dailyWeatherModel![i].timeDate!)
            //print("days: \(days)")
            if unitChange == "convertToImperial" {
                temperatureMax = dailyWeatherModel![i].temperatureMax
                print("temperatureMax: \(temperatureMax)")
                temperatureMin = dailyWeatherModel![i].temperatureMin
                dailyUnitLbl.text = "\u{00B0}" + "F"
            } else {
                temperatureMax = dailyWeatherModel![i].temperatureMax.toCelcius()
                temperatureMin = dailyWeatherModel![i].temperatureMin.toCelcius()
                dailyUnitLbl.text = "\u{00B0}" + "C"
            }
            
            let valueMax = ChartDataEntry(x: Double(i), y: temperatureMax)
            let valueMin = ChartDataEntry(x: Double(i), y: temperatureMin)
            lineChartEntryMax.append(valueMax)
            lineChartEntryMin.append(valueMin)
            days.append(day)
        }
        let temperarureMaxLine = LineChartDataSet(values: lineChartEntryMax, label: "days")
        temperarureMaxLine.axisDependency = .left
        temperarureMaxLine.setColor(UIColor.red.withAlphaComponent(0.5))
        temperarureMaxLine.circleColors = [NSUIColor.red]
        temperarureMaxLine.circleRadius = 6.0
        temperarureMaxLine.circleHoleRadius = 4.0
        temperarureMaxLine.circleHoleColor = UIColor.black.withAlphaComponent(0.6)
        temperarureMaxLine.lineWidth = 2.0
        temperarureMaxLine.drawCirclesEnabled = true
        temperarureMaxLine.drawCircleHoleEnabled = true
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.locale = Locale.current
        temperarureMaxLine.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
        
        let temperarureMinLine = LineChartDataSet(values: lineChartEntryMin, label: "days")
        temperarureMinLine.axisDependency = .left
        temperarureMinLine.setColor(UIColor.blue.withAlphaComponent(0.5))
        temperarureMinLine.circleColors = [NSUIColor.blue]
        temperarureMinLine.circleRadius = 6.0
        temperarureMinLine.circleHoleRadius = 4.0
        temperarureMinLine.circleHoleColor = UIColor.black.withAlphaComponent(0.6)
        temperarureMinLine.setCircleColor(UIColor.blue)
        temperarureMinLine.lineWidth = 2.0
        temperarureMinLine.drawCirclesEnabled = true
        temperarureMinLine.drawCircleHoleEnabled = true
        temperarureMinLine.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
        // x axis setup
        let xAxis = dailyChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = UIColor.white
        xAxis.labelTextColor = UIColor.white
        xAxis.labelFont = UIFont(name: "Avenir", size: 10)!
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        
        // y axis setup
        let leftAxis = dailyChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelTextColor = UIColor.white
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisLineColor = UIColor.white
        leftAxis.labelFont = UIFont(name: "Avenir", size: 10)!
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: numberFormatter)
        dailyChartView.rightAxis.enabled = false
        dailyChartView.legend.enabled = true
        dailyChartView.legend.textColor = UIColor.white
        dailyChartView.legend.formSize = CGFloat(6.0)
        
        let lineChartData = LineChartData()
        
        lineChartData.addDataSet(temperarureMaxLine)
        lineChartData.addDataSet(temperarureMinLine)
        lineChartData.setValueFont(UIFont(name: "Avenir", size: 8))
        lineChartData.setDrawValues(true)
        lineChartData.setValueTextColor(UIColor.white)
        dailyChartView.drawGridBackgroundEnabled = false
        dailyChartView.data = lineChartData
        dailyChartView.notifyDataSetChanged()
        dailyChartView.chartDescription?.text = "Daily Forecast Trend"
        dailyChartView.chartDescription?.textColor = UIColor.white
    }
  
}


