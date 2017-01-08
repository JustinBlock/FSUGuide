//
//  PointsOfInterestTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PointsOfInterestTableViewCell : UITableViewCell <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *mapCenterButton;

@end
