//
//  StationCreateController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 3/10/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationCreateController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIPickerView *latitude;
    IBOutlet UIPickerView *longitude;
    IBOutlet UITextField *nameField;
}

@end
