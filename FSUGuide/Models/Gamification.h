//
//  Gamification.h
//  FSUGuide
//
//  Created by Justin Block on 6/25/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gamification : NSObject

@property (nonatomic, readonly) long points;
-(BOOL)increasePointsByDoubleValue:(long)increaseValue;

@end
