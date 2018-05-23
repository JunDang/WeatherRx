//
//  WeatherForecastTableViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-10.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit


class WeatherForecastTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(HourlyForecastTableViewCell.self, forCellReuseIdentifier: "HourlyCell")
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: "DailyCell")
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell1: HourlyForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HourlyCell", for: indexPath) as! HourlyForecastTableViewCell
            return cell1
        } else {
            let cell2: DailyForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyForecastTableViewCell
            return cell2
        }
    }
}
