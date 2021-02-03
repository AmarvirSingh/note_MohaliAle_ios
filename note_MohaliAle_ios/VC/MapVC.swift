//
//  MapVC.swift
//  note_MohaliAle_ios
//
//  Created by Amarvir Mac on 04/02/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
