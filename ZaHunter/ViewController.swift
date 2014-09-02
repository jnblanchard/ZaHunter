//
//  ViewController.swift
//  ZaHunter
//
//  Created by John Blanchard on 8/6/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    let locationManager = CLLocationManager()
    let pizzaArray = NSMutableArray()

                            
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("IDcell") as UITableViewCell
        let item = pizzaArray[indexPath.row] as MKMapItem
        cell.textLabel.text = item.name
        return cell
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return pizzaArray.count
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        for location in locations {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location as CLLocation, completionHandler: { (placemarks, error) -> Void in
                let placemark:CLPlacemark = placemarks[0] as CLPlacemark
                let location = placemark.location as CLLocation
                let request:MKLocalSearchRequest = MKLocalSearchRequest()
                request.naturalLanguageQuery = "restaurants"
                let span = MKCoordinateSpanMake(1.0, 1.0)
                request.region = MKCoordinateRegionMake(location.coordinate, span)
                let search = MKLocalSearch(request: request)
                search.startWithCompletionHandler( { (response, error) -> Void in
                    for item in response.mapItems
                    {
                        self.pizzaArray.addObject(item)
                    }
                })
            })
            locationManager.stopUpdatingLocation()
            break
        }
        self.tableView.reloadData()
    }
}

