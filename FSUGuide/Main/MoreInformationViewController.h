//
//  MoreInformationViewController.h
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//
/*
 Called from Explore FSU -> More Information cells
*/

#import <UIKit/UIKit.h>

@interface MoreInformationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *informationImage;
@property (weak, nonatomic) IBOutlet UILabel *informationTitle;
@property (weak, nonatomic) IBOutlet UITextView *informationText;

// Set on segue
@property (strong, nonatomic) UIImage* imageToLoad;
@property (strong, nonatomic) NSString* titleToLoad;
@property (strong, nonatomic) NSString* textToLoad;

-(void)setViewControllerWithImage:(UIImage *)image andTitle:(NSString *)title andMessageBody:(NSString *)messageBody;

@end
