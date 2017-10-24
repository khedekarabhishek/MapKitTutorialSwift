//
//  ViewController.swift
//  UserCurrentLocation
//
//  Created by Abhishek Khedekar on 21/10/17.
//  Copyright © 2017 Abhishek Khedekar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

    var locationnManager: CLLocationManager!
    let regionRadius:CLLocationDistance = 1000
    var artworks = [Artwork]()
    
    @IBOutlet weak var myMapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // it was created by abhishek 
        let myCurrentLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnCurrentLocation(location: myCurrentLocation)
    
//        let artWork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//        myMapview.addAnnotation(artWork)
        myMapview.delegate = self
        
        loadInitialData()
        myMapview.addAnnotations(artworks)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        determineMyCurrentLocation()
    }
    
    //MARK: User Defined Methods
    
    func loadInitialData(){
        do {
            if let file = Bundle.main.url(forResource: "PublicArt", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    let jsonData = JSONValue.fromObject(object: object as AnyObject)?["data"]?.array
                    for item in jsonData!{
                        if let artworkJSON = item.array{
                            let artwork = Artwork.fromJSON(json: artworkJSON )
                            artworks.append(artwork)
                        }
                    }
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func determineMyCurrentLocation()  {
        locationnManager = CLLocationManager()
        locationnManager.delegate = self;
        locationnManager.desiredAccuracy = kCLLocationAccuracyBest
        locationnManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationnManager.startUpdatingLocation()
        }
    }
    
    func centerMapOnCurrentLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2,regionRadius * 2)
        myMapview.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: locationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let myCurrentLocation = CLLocation(latitude: 18.5083, longitude: 73.8567)
        
        centerMapOnCurrentLocation(location: myCurrentLocation)
        
        print("User latitude:\(latitude) and User Longitude:\(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    // MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

