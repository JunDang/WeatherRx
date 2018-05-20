//
//  HourlyForecastViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-13.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography


class HourlForecastViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView?
    func setupCollectionView() {
        let leftAndRightPaddings: CGFloat = 5.0
        let numberOfItemsPerRow: CGFloat = 24.0
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width - leftAndRightPaddings*(numberOfItemsPerRow+1)) / numberOfItemsPerRow
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width, 90)
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        collectionView!.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(collectionView!)
    }
    
    // MARK: <UICollectionViewDataSource>
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HourlyForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyForecastCell
        return cell
    }
}
