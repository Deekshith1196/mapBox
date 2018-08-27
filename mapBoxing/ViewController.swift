//
//  ViewController.swift
//  mapBoxing
//
//  Created by Deekshith Maram on 8/2/18.
//  Copyright © 2018 Deekshith Maram. All rights reserved.
//

import UIKit
import Mapbox


class CustomPointAnnotation : NSObject, MGLAnnotation {
    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // Custom properties that we will use to customize the annotation's image.
    var image: UIImage?
    var reuseIdentifier: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class ViewController: UIViewController,MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        let mapView = MGLMapView(frame: view.bounds)
      //  mapView.styleURL = MGLStyle.lightStyleURL
        mapView.styleURL = url
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.setCenter(CLLocationCoordinate2D(latitude: 44.971, longitude: -93.261), zoomLevel: 10, animated: false)
        view.addSubview(mapView)
        mapView.delegate = self
        
        
        var points = [CustomPointAnnotation]()
        
        
        // Create four new point annotations with specified coordinates and titles.
        
        var pointA = CustomPointAnnotation(coordinate: (CLLocationCoordinate2D(latitude: 17.4239, longitude: 78.4738)), title: "tankbund", subtitle: "Hyderabad")
        pointA.reuseIdentifier = "marker1"
        let label = UILabel(frame: CGRect(x: 55, y: 0, width: 100, height: 20))
        let image = UIImageView(frame: CGRect(x: 35, y: 10, width: 30, height: 50))
        label.text = "1"
        image.image = UIImage(named: "pin")
        
    
        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        markerView.addSubview(label)
        markerView.addSubview(image)
        pointA.image = UIImage(view: markerView)
        
        
        var pointB = CustomPointAnnotation(coordinate: (CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945)), title: "Eiffel Tower", subtitle: "Paris")
        pointB.reuseIdentifier = "marker2"
        let label1 = UILabel(frame: CGRect(x: 65, y: 0, width: 100, height: 20))
        let image1 = UIImageView(frame: CGRect(x: 35, y: 10, width: 30, height: 50))
        label1.text = "2"
        image1.image = UIImage(named: "pin")
    
    
        let markerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        markerView1.addSubview(label1)
        markerView1.addSubview(image1)
        pointB.image = UIImage(view: markerView1)
        
        
        var pointC = CustomPointAnnotation(coordinate: (CLLocationCoordinate2D(latitude: 18.9220, longitude: 72.83475)), title: "Gateway of india", subtitle: "Mumbai")
        pointC.reuseIdentifier = "marker3"
        let label2 = UILabel(frame: CGRect(x: 55, y: 0, width: 100, height: 20))
        let image2 = UIImageView(frame: CGRect(x: 35, y: 10, width: 30, height: 50))
        label2.text = "3"
        image2.image = UIImage(named: "pin")
        
        let markerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        markerView2.addSubview(label2)
        markerView2.addSubview(image2)
        pointC.image = UIImage(view: markerView2)
        
        
        var pointD = CustomPointAnnotation(coordinate: (CLLocationCoordinate2D(latitude: 44.971, longitude: -93.261)), title: "Minneapolis", subtitle: "USA")
        pointC.reuseIdentifier = "marker4"
        let label3 = UILabel(frame: CGRect(x: 55, y: 0, width: 100, height: 20))
        let image3 = UIImageView(frame: CGRect(x: 35, y: 10, width: 30, height: 50))
        label3.text = "4"
        image3.image = UIImage(named: "placeholder")
        
        let markerView3 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        markerView3.addSubview(label3)
        markerView3.addSubview(image3)
        pointD.image = UIImage(view: markerView3)
        
        points.append(pointA)
        points.append(pointB)
        points.append(pointC)
        points.append(pointD)
    
        mapView.addAnnotations(points)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let point = annotation as? CustomPointAnnotation,
           let image = point.image,
           let reuseIdentifier = point.reuseIdentifier {
            
            if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier) {
                // The annotatation image has already been cached, just reuse it.
                return annotationImage
            } else {
                // Create a new annotation image.
                return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            }
        }
        
        // Fallback to the default marker image.
        return nil
    }
    
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
  
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let source = MGLVectorTileSource(identifier: "historical-places", configurationURL: URL(string: "mapbox://examples.5zzwbooj")!)
        style.addSource(source)
        let layer = MGLCircleStyleLayer(identifier: "landmarks", source: source)
        layer.sourceLayerIdentifier = "HPC_landmarks-b60kqn"
        layer.circleColor = NSExpression(forConstantValue: #colorLiteral(red: 0.67, green: 0.28, blue: 0.13, alpha: 1))
        layer.circleOpacity = NSExpression(forConstantValue: 0.8)
       // layer.circleRadius = NSExpression(format: "2018 - Constructi")
        layer.circleRadius = NSExpression(format: "(2018 - Constructi) / 10")


        let zoomStops = [
            10: NSExpression(format: "(Constructi - 2018) / 30"),
            13: NSExpression(format: "(Constructi - 2018) / 10")
        ]

        layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", zoomStops)


        style.addLayer(layer)
    }

}
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

