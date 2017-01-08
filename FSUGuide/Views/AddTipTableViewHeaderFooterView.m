//
//  AddTipTableViewHeaderFooterView.m
//  FSUGuide
//
//  Created by Justin Block on 6/24/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "AddTipTableViewHeaderFooterView.h"
#import "UIColor+FSUGuideColors.h"

@implementation AddTipTableViewHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addTipTextField.placeholder = @"Write your tip/suggestion about FSU";
    self.addTipButton.tintColor = [UIColor fsuGarnetColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addTipButtonPressed:(id)sender {
    if(![self.addTipTextField.text isEqualToString:@""]) {
        // Add tip to tips table
        PFObject *studentTaskListProgressObject = [PFObject objectWithClassName:@"Tips"];
        studentTaskListProgressObject[@"title"] = self.addTipTextField.text;
        studentTaskListProgressObject[@"user"] = [PFUser currentUser];
        studentTaskListProgressObject[@"approved"] = [NSNumber numberWithBool:YES];
        studentTaskListProgressObject[@"deleted"] = [NSNumber numberWithBool:NO];
        // Save
        [studentTaskListProgressObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                // If an error let the user know
                UIAlertController* alert = [UIAlertController
                                            alertControllerWithTitle:nil
                                            message:@"Your tip could not be posted. Please try again later."
                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {}];
                
                [alert addAction:okAction];
                [self.tipsDelegate displayAlert:alert];
            } else {
                // Reset the value in the text field and make it unselected
                self.addTipTextField.text = @"";
                [self.tipsDelegate addPost:studentTaskListProgressObject];
            }
        }];
    }
    [self.addTipTextField resignFirstResponder];
}

@end
