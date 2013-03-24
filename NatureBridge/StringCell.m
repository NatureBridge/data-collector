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
{
    [super layoutSubviews];
    
    [self.stringField setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                          CELL_PADDING,
                                          INPUT_WIDTH,
                                          self.frame.size.height - CELL_PADDING * 2)];
}

- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if(self) {
        // Initialization code                
        [self setStringField:[[UITextView alloc] init]];
        stringField.tag = 3;
        stringField.font = [UIFont systemFontOfSize:17.0];
        stringField.textColor = [UIColor blueColor];
        stringField.layer.borderWidth = 1.0f;
        stringField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        stringField.backgroundColor = [UIColor whiteColor];
        stringField.editable = YES;
        stringField.allowsEditingTextAttributes = YES;
        [stringField setReturnKeyType:UIReturnKeyDefault];
        [stringField setDelegate:self];
        [[self contentView] addSubview:stringField];
    }
    return self;
}

// Delegate method to Check if Edit enabled (May be View Only mode)
- (BOOL)textViewShouldBeginEditing:(UITextField *)textField
{   
    return([NBSettings editFlag]);
}

+ (NSString *)identifier
{
    return @"StringCell";
}

- (void)updateValues
{
    [super updateValues];
    
    if([[[self data] stringValue] length] < 1 && [[[self field] label] isEqualToString:@"School/Organization Name"]) {
        [[self data] setStringValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"FSSchool"]];
    }
    
    [stringField setText:[[self data] stringValue]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != stringField) {
        [stringField endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [[self data] setStringValue:[textView text]];
    
    if ([[[self field] label] isEqualToString:@"School/Organization Name"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[textView text] forKey:@"FSSchool"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
