//
//  PointsOfInterestTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "PointsOfInterestTableViewCell.h"
#import "CustomMKAnnotation.h"

@implementation PointsOfInterestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.map.delegate = self;
    
    [self configureMapCoordinates];
    [self addPointsOfInterest];
}

-(void)configureMapCoordinates {
    // Set the map to fsu campus
    CLLocationCoordinate2D coord = {.latitude =  30.4418223, .longitude =  -84.2990146};
    MKCoordinateSpan span = {.latitudeDelta =  .014, .longitudeDelta =  .012};
    MKCoordinateRegion region = {coord, span};
    [self.map setRegion:region];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma map annotations
-(void)addPointsOfInterest {
    NSArray* pointsOfInterest = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PointsOfInterest" ofType:@"plist"]];
    
    for (id pointOfInterest in pointsOfInterest) {
        double latitude = [[pointOfInterest valueForKey:@"latitude"] doubleValue];
        double longitude = [[pointOfInterest valueForKey:@"longitude"] doubleValue];
        [self createMapAnnotationWithTitle:[pointOfInterest objectForKey:@"locName"]
                            andCoordinates:CLLocationCoordinate2DMake(latitude,
                                                                      longitude)
                                andAddress:[pointOfInterest objectForKey:@"address"]];
    }
}

-(void)createMapAnnotationWithTitle:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinate andAddress:(NSString *)address {
    CustomMKAnnotation *annotation = [[CustomMKAnnotation alloc] initWithTitle:title location:coordinate address:address];
    [self.map addAnnotation:annotation];
}

- (IBAction)mapCenterButtonClicked:(id)sender {
    [self configureMapCoordinates];
}

#pragma MKMapView protocol
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[CustomMKAnnotation class]]) {
        CustomMKAnnotation* myAnnotation = (CustomMKAnnotation *)annotation;
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomMKAnnotation"];
        
        // Create view if doesnt exist
        if(annotationView == nil) {
            annotationView = myAnnotation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil; // Otherwise return nil
}

@end
