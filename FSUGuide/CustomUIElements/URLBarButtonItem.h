//
//  URLBarButtonItem.h
//  FSUGuide
//
//  Created by Justin Block on 6/30/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//
//  Used for storing a url of the bar button item so that it can be used as a share button

#import <UIKit/UIKit.h>

@interface URLBarButtonItem : UIBarButtonItem
@property (nonatomic, strong) NSURL* url;
@end
