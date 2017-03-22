//
//  ViewController.swift
//  EggHunt
//
//  Created by Chris Smith on 22/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var eggs : [Egg] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eggs = getAllEggs()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                // Spawn an egg
                
                if let coord = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 100000.0
                    let randomLong = (Double(arc4random_uniform(200)) - 100.0) / 10000.0
                    annotation.coordinate.latitude += randomLat
                    annotation.coordinate.longitude += randomLong
                    self.mapView.addAnnotation(annotation)
                }
            })
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 500, 500)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 500, 500)
            mapView.setRegion(region, animated: false)
        }
    }
    
}




















