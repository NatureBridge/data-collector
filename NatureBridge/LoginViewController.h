//
//  LoginControllerViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/18/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
<UITextFieldDelegate>
{
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UILabel *promptLabel;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
}
- (IBAction) doContinueButton;
@end
