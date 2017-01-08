//
//  TodoTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/15/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "TodoTableViewCell.h"
#import "UIColor+FSUGuideColors.h"

@implementation TodoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Set checkbox color
    self.checkButton.backgroundColor = [UIColor fsuGarnetColor];
    [self.checkButton setTintColor: [UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
    Changes the image when checked
*/
- (IBAction)checkBoxClicked:(UIButton *)sender {
    // If user completed it
    if(self.isTaskComplete) {
        // Mark todo task incomplete
        [sender setBackgroundImage:[UIImage imageNamed:@"checkBoxEmpty"] forState:UIControlStateNormal];
        [self.todoDelegate markTaskIncomplete: self.taskId];
    } else {
        // Mark todo task complete
        [sender setBackgroundImage:[UIImage imageNamed:@"checkBoxChecked"] forState:UIControlStateNormal];
        [self.todoDelegate markTaskComplete: self.taskId];
    }
    
    self.isTaskComplete = !self.isTaskComplete;
}

@end
