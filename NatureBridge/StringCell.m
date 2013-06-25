//
//  StringCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "StringCell.h"
#import "ObservationViewController.h"
#import "NBSettings.h"
#import <QuartzCore/QuartzCore.h>

@implementation StringCell

@synthesize stringField;

- (void)layoutSubviews
{   //NSLog(@"StringCell: layoutSubview");
    [super layoutSubviews];
    [self.stringField setFrame:[self inputFrame]];
}

- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{   //NSLog(@"StringCell: initWithField");
    self = [super initWithField:field forObservation:observation];
    if (self) {
        // Initialization code
        stringField = [[UITextField alloc] init];
        stringField.tag = 3;
        stringField.font = [NBSettings cellFont];
        stringField.textColor = [UIColor blueColor];
        stringField.layer.borderWidth = 2.0f;
        stringField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        stringField.backgroundColor = [UIColor whiteColor];
        stringField.allowsEditingTextAttributes = YES;
        [stringField setReturnKeyType:UIReturnKeyDefault];
        [stringField setDelegate:self];
        [[self contentView] addSubview:stringField];
    }
    return self;
}

// Delegate: Check if Edit enabled (May be View Only mode)
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{   //NSLog(@"StringCell: textFieldShouldBeginEditing");
    return([NBSettings editFlag]);
}

+ (NSString *)identifier
{
    return @"StringCell";
}
// Set Current Value in String Field
- (void)updateValues
{   //NSLog(@"StringCell: updateValues");
    [super updateValues];
    // If School/Oragnaization field and value is empty use the current default
    if([[[self data] stringValue] length] < 1 && [[[self field] label] isEqualToString:@"School/Organization Name"]) {
        [[self data] setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"FSSchool"]];
    }
    [stringField setText:[[self data] stringValue]];
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{   //NSLog(@"StringCell: textFieldShouldReturn.");
    [textField resignFirstResponder];
    return YES;
}
// Delegate: End Editing method Save New Value
- (void)textFieldDidEndEditing:(UITextField *)textField
{   //NSLog(@"StringCell: textViewDidEndEditing");
    [[self data] setStringValue:[stringField text]];
    if ([[[self field] label] isEqualToString:@"School/Organization Name"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[stringField text] forKey:@"FSSchool"];
    }
}
@end