//
//  OrientationTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/19/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "OrientationTableViewCell.h"
#import "UIColor+FSUGuideColors.h"

@implementation OrientationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *orientationDate = [defaults objectForKey:@"orientationDate"];
    
    // Set colors
    self.backgroundColor =[UIColor fsuGoldColor];
    self.daysLeftLabel.textColor = [UIColor fsuGarnetColor];
    
    // Date not set yet
    if(orientationDate == nil) {
        self.daysLeftLabel.hidden = YES;
        self.dayOfTheWeekLabel.hidden = YES;
        self.fullDateLabel.hidden = YES;
        self.daysLeftTitleLabel.text = @"Set orientation date";
    }
    // Set days left to orientation
    else {
        NSDateFormatter *dateFormatDayOfTheWeek = [[NSDateFormatter alloc] init];
        [dateFormatDayOfTheWeek setDateFormat:@"EEEE"];
        self.dayOfTheWeekLabel.text = [dateFormatDayOfTheWeek stringFromDate:orientationDate];
        
        NSDateFormatter *dateFormatFull = [[NSDateFormatter alloc] init];
        [dateFormatFull setDateFormat:@"MMM d, yyyy"];
        self.fullDateLabel.text = [dateFormatFull stringFromDate:orientationDate];
        
        // Set days left
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents * dateComponent = [gregorianCalendar components:( NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        [dateComponent setMinute:0];
        [dateComponent setHour:0];
        NSDate *beginningOfCurrentDay = [gregorianCalendar dateFromComponents:dateComponent];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:beginningOfCurrentDay
                                                              toDate:orientationDate
                                                             options:NSCalendarWrapComponents];
        self.daysLeftLabel.text = [NSString stringWithFormat:@"%ld", [components day]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
