//
//  HomeViewController.swift
//  Mirage
//
//  Created by Adarsh Ponaka on 9/7/19.
//  Copyright © 2019 Adarsh Ponaka. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var locationLabel: UILabel!
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let location = manager.location!
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error{
                print(error?.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let street = placemark.thoroughfare ?? ""
            let city = placemark.subAdministrativeArea ?? ""
            let state = placemark.administrativeArea ?? ""
            let zipcode = placemark.postalCode ?? ""
            let country = placemark.country ?? ""
            self.locationLabel.text = "\(streetNumber) \(street) \(city), \(state) \n \(zipcode) \(country)"
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func webTapped(_ sender: Any) {
        performSegue(withIdentifier: "webportal", sender: sender)

    }
    
    @IBAction func backTap(_ sender: Any) {
        performSegue(withIdentifier: "backLogin", sender: sender)
    }
}
