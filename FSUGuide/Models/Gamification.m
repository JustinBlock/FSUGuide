//
//  Gamification.m
//  FSUGuide
//
//  Created by Justin Block on 6/25/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "Gamification.h"

@interface Gamification()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation Gamification

#pragma Setting Points Value
-(BOOL)increasePointsByDoubleValue:(long)increaseValue {
    long newPointValue = self.points + increaseValue;
    [self.defaults setObject:[NSNumber numberWithLong:newPointValue] forKey:@"gamificationPoints"];
    
    return YES;
}

#pragma Lazy Loading
-(long)points {
    return [[self.defaults valueForKey:@"gamificationPoints"] doubleValue];
}

-(NSUserDefaults *)defaults {
    if(_defaults == nil) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

@end
