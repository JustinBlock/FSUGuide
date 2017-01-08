//
//  CustomMKAnnotation.h
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//
// Credits to https://bakyelli.wordpress.com/2013/10/13/creating-custom-map-annotations-using-mkannotation-protocol/ for a guide on using MKAnnotation

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomMKAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *address;

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)coordinate address:(NSString *)address;
-(MKAnnotationView *)annotationView;

@end
