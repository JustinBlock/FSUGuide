//
//  UserPostTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/22/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "UserPostTableViewCell.h"

@implementation UserPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)longPressOfCell:(id)sender {
    UIGestureRecognizer* gesture = (UIGestureRecognizer*)sender;
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [self.tipsPostDelegate showPopoverForPostAtRow:self.userPostRow];
    }
}

@end
