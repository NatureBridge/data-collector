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
    int latDeg, latMin, latSec;
    int lonDeg, lonMin, lonSec;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *latitudeField;
    UIPickerView *latPicker;
    IBOutlet UITextField *longitudeField;
    UIPickerView *lonPicker;
}

@end
