//
//  ViewController.swift
//  EggHunt
//
//  Created by Chris Smith on 22/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var eggs : [Egg] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eggs = getAllEggs()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                // Spawn an egg
                if let coord = self.manager.location?.coordinate {
                    
                    let eggs = self.eggs[Int(arc4random_uniform(UInt32(self.eggs.count)))]
                    
                    let annotation = EggAnnotation(coord: coord, egg: eggs)
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "001-easter-bunny")
            var frame = annotationView.frame
            frame.size.height = 50
            frame.size.width = 50
            annotationView.frame = frame
            
            return annotationView
        }
        
        let egg = (annotation as! EggAnnotation).egg
        
        annotationView.image = UIImage(named: egg.imageName!)
        var frame = annotationView.frame
        frame.size.height = 50
        frame.size.width = 50
        annotationView.frame = frame
        
        return annotationView
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 600, 600)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 600, 600)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            if let coord = self.manager.location?.coordinate {
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    let egg = (view.annotation! as! EggAnnotation).egg
                    egg.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "EGGcellent!", message: "You've got EGGxactly what you wanted!", preferredStyle: .alert)
                    
                    let basketAction = UIAlertAction(title: "Basket", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "basketSegue", sender: nil)
                    })
                    alertVC.addAction(basketAction)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okayAction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    let alertVC = UIAlertController(title: "Ooops!", message: "The egg is too far away to catch the egg. Move closer to catch it.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okayAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
    }
    
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 600, 600)
            mapView.setRegion(region, animated: false)
        }
    }
    
}




















