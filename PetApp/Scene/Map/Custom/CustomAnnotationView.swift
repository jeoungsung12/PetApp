//
//  CustomAnnotationView.swift
//  PetApp
//
//  Created by 정성윤 on 3/27/25.
//

import Foundation
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation, ReusableIdentifier {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let entity: MapEntity
    
    init(entity: MapEntity) {
        self.coordinate = CLLocationCoordinate2D(latitude: entity.lat, longitude: entity.lon)
        self.title = entity.name
        self.subtitle = entity.address
        self.entity = entity
        super.init()
    }
}

final class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.image = UIImage(named: "annotation")
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.centerOffset = CGPoint(x: 0, y: -self.frame.size.height / 2)
        
        self.canShowCallout = true
        if let customAnnotation = annotation as? CustomAnnotation {
            let calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            calloutView.configure(with: customAnnotation.entity)
            self.detailCalloutAccessoryView = calloutView
        }
    }
}
