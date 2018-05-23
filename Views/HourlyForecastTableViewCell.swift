//
//  HourlyForecastTableViewCell.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-17.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class HourlyForecastTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    private var didSetupConstraints = false
    var collectionView: UICollectionView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      self.selectionStyle = UITableViewCellSelectionStyle.none
      
      setupCollectionView()
      setStyle()
      layoutView()
  }
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

   override func updateConstraints() {
     if didSetupConstraints {
        super.updateConstraints()
        return
     }
     layoutView()
     super.updateConstraints()
     didSetupConstraints = true
    }
}
// MARK: - collectionView
extension HourlyForecastTableViewCell {
    func setupCollectionView() {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = UICollectionViewScrollDirection.horizontal
       layout.minimumInteritemSpacing = 0.0
       layout.estimatedItemSize = CGSize(42, 90)
       layout.scrollDirection = UICollectionViewScrollDirection.horizontal
       print("layout: " + "\(layout)")
       collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: layout)
       collectionView!.dataSource = self
       collectionView!.delegate = self
       collectionView!.backgroundColor = UIColor.black.withAlphaComponent(0.2)
       collectionView!.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "Cell")
       self.contentView.addSubview(collectionView!)
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

private extension HourlyForecastTableViewCell {
    func layoutView() {
        constrain(collectionView!) {
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.height == 90
       }
    }
}

private extension HourlyForecastTableViewCell {
    func setStyle() {
      self.backgroundColor = UIColor.clear
    }
}
    
    


