//
//  ViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-25.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import UIKit
import Cartography
import FXBlurView
import Unbox

class ViewController: UIViewController {
    
    fileprivate let gradientView = UIView()
    fileprivate let overlayView = UIImageView()
    fileprivate let backgroundView = UIImageView()
    fileprivate let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
      
        let image = try? FlickrService().searchPhotoAtLat(lat: "43.6532" , lon: "-79.3832", currentWeather: "cloudy")
        self.render(image: image)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func render(image: UIImage?){
        if let image = image {
            backgroundView.image = image
            overlayView.image = image.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
            overlayView.alpha = 0
        }
    }
}

private extension ViewController{
    func setup(){
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        overlayView.contentMode = .scaleAspectFill
        overlayView.clipsToBounds = true
        view.addSubview(overlayView)
        view.addSubview(gradientView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
    }
}

// MARK: Layout
extension ViewController{
    func layoutView() {
        constrain(backgroundView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(overlayView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(gradientView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        constrain(scrollView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
  }
}


