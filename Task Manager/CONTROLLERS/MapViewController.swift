//
//  MapViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 05/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var selectedAnnotation: MKPointAnnotation?
    var locationAddress: String?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var viewAddress: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewAddress.layer.cornerRadius = 27
        viewAddress.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        viewAddress.layer.borderWidth = 4
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(TapAction(_:)))
        mapView.addGestureRecognizer(gesture)
        
        if let annotation = selectedAnnotation {
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
            labelAddress.text = locationAddress
            viewAddress.isHidden = false
        }
        
    }
    
    @objc func TapAction (_ sender: UITapGestureRecognizer) {
        let loc = sender.location(in: mapView)
        let locCoord = mapView.convert(loc, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation!)
        }
        selectedAnnotation = annotation
        mapView.addAnnotation(annotation)
        
        let queueUserInteractive = DispatchQueue.global(qos: .userInteractive)
        queueUserInteractive.async {
            GeoService().obtainAddress(lat: locCoord.latitude, lon: locCoord.longitude) { result in
                DispatchQueue.main.async {
                    self.viewAddress.isHidden = false
                    
                    switch result {
                    case .success(let dataResponse):
                        self.locationAddress = dataResponse.address
                        self.labelAddress.text = self.locationAddress
                    case .failure:
                        self.locationAddress = "(не определён)"
                        self.labelAddress.text = "(не удалось определить адрес)"
                    }
                }
            }
        }
    }

}
