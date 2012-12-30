//
//  SchoolViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/19/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolViewController : UIViewController
<UITextFieldDelegate>
{
    IBOutlet UILabel *promptLabel;
    IBOutlet UITextField *instructorField;
    IBOutlet UITextField *schoolField;
}
- (IBAction) doContinueButton;
@end
