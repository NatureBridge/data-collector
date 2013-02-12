//
//  HomeViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ARROW_WIDTH 20.0

@interface HomeViewController : UIViewController
{
    IBOutlet UILabel *warningLabel;
    IBOutlet UIButton *projectButton;
    IBOutlet UILabel *modeLabel;
}
- (IBAction) doAddButton;
- (IBAction) doEditButton;
- (IBAction) doChangeProjectButton;
- (IBAction) doTransmitButton;
- (void) updateWarning;

@end
