//
//  CustomMKAnnotation.m
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "CustomMKAnnotation.h"

@implementation CustomMKAnnotation

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)coordinate address:(NSString *)address {
    self = [super init];
    if(self) {
        _title = title;
        _coordinate = coordinate;
        _address = address;
    }
    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView* annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomMKAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"mapPOI"];
    
    // Create directions button
    UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionsButton.frame = CGRectMake(30, 30.0, 30.0, 30.0);
    [directionsButton setImage:[UIImage imageNamed:@"directionsMapIcon"] forState:UIControlStateNormal];
    [directionsButton addTarget:self action:@selector(directionsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.rightCalloutAccessoryView = directionsButton;
 
    return annotationView;
}

/*
    When the user clicks the address button in the points of interest map
*/
-(void)directionsButtonClicked {
    NSString *encodedAddress = [self.address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *formattedAddress = [NSString stringWithFormat:@"https://maps.apple.com?q=%@", encodedAddress];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedAddress]];
}

@end
