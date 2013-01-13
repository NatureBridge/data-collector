//
//  HomeViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    IBOutlet UILabel *warningLabel;
}

- (IBAction) doAddButton;
- (IBAction) doEditButton;
- (IBAction) doChangeProjectButton;
- (IBAction) doTransmitButton;
- (void) updateWarning;

@end
