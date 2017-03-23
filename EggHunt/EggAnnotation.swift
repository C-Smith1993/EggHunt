//
//  EggAnnotation.swift
//  EggHunt
//
//  Created by Chris Smith on 23/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import MapKit

class EggAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var egg : Egg
    
    init(coord: CLLocationCoordinate2D, egg: Egg){
       self.coordinate = coord
       self.egg = egg
    }
}
