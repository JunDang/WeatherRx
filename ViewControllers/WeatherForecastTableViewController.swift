//
//  WeatherForecastTableViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-10.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class WeatherForecastTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView(frame: CGRect.zero)
    //var weatherViewModel: WeatherViewModel?
    var weatherForecastModel: WeatherForecastModel?
    //private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(HourlyForecastTableViewCell.self, forCellReuseIdentifier: "HourlyCell")
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: "DailyCell")
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.5)
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
      
     }
    /*init(with weatherViewModel: WeatherViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.weatherViewModel = weatherViewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.row == 0 {
            let cell: HourlyForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HourlyCell", for: indexPath) as! HourlyForecastTableViewCell
            if let weatherForecastModel = weatherForecastModel {
               cell.weatherForecastModel = weatherForecastModel
               cell.collectionView?.reloadData()
            } else {
                
            }
            return cell
        } else {
            let cell: DailyForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyForecastTableViewCell
            if let weatherForecastModel = weatherForecastModel {
               let dailyWeatherModel = weatherForecastModel.daily?.dailyWeatherModel
                 //print("dailycount: " + "\(dailyWeatherModel?.count)")
                 let dailyForecastData = dailyWeatherModel![indexPath.row]
                 cell.updateDailyCell(with: dailyForecastData)
                 //print("dailyForecastData: " + "\(dailyForecastData)")
            } else {
                
            }
             return cell
       }
    }
  
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44.0
        if indexPath.row == 0 {
            height = 90.0
        }
        return height
    }
}
