//
//  LogoutTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/20/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "LogoutTableViewCell.h"
#import "UIColor+FSUGuideColors.h"

@implementation LogoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.logoutButton.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor fsuGarnetColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
