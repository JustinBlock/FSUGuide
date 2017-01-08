//
//  GamificationTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/25/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "GamificationTableViewCell.h"
#import "UIColor+FSUGuideColors.h"
#import "Gamification.h"

@interface GamificationTableViewCell()
@property (nonatomic, strong) Gamification* gamification;
@end

@implementation GamificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor fsuGoldColor];
    self.infoButton.tintColor = [UIColor fsuGarnetColor];
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld",self.gamification.points];
    
    // Set selected background color
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor fsuGoldColor];
    [self setSelectedBackgroundView:backgroundView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Provide the user with information about FSU Points
- (IBAction)pressedInfoButton:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"FSU Points"
                                                                   message:@"FSU Points are gained by using the FSU Guide app. You'll gain points by completing new student tasks, posting tips and more! Currently points can't be redeemed for anything tangible but theirs always bragging rights (hold press on your points to share them)"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:okAction];
    [self.profileTableViewDelegate presentAlertUsingAlertController:alert];
}

/*
 When the user long presses
*/
- (IBAction)longPressed:(id)sender {
    UIGestureRecognizer* gesture = (UIGestureRecognizer*)sender;
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [self.profileTableViewDelegate showPopoverForSharingFSUPoints];
    }
}

#pragma Lazy Loading
-(Gamification *)gamification {
    if(_gamification == nil) {
        _gamification = [[Gamification alloc] init];
    }
    return _gamification;
}

@end
