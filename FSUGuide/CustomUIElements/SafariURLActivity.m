//
//  SafariURLActivity.m
//  FSUGuide
//
//  Created by Justin Block on 6/30/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "SafariURLActivity.h"

@implementation SafariURLActivity
- (NSString *)activityType
{
    return @"Open in Safari";
}

- (NSString *)activityTitle
{
    return @"Open in Safari";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"safariAppActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id element in activityItems) {
        if([element isKindOfClass:[NSURL class]]) {
            self.url = element;
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    BOOL completed = [[UIApplication sharedApplication] openURL:self.url];
    
    [self activityDidFinish:completed];
}

+(UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}
@end
