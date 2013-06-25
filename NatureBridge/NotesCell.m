//
//  NotesCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NotesCell.h"
#import "ObservationViewController.h"
#import "NBSettings.h"
#import <QuartzCore/QuartzCore.h>

@implementation NotesCell

@synthesize noteField;

- (void)layoutSubviews
{   //NSLog(@"NotesCell: layoutSubview");
    [super layoutSubviews];
    [self.noteField setFrame:[self notesFrame]];
}

- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{   //NSLog(@"NotesCell: initWithField");
    self = [super initWithField:field forObservation:observation];
    if (self) {
        // Initialization code
        noteField = [[UITextView alloc] init];
        noteField.tag = 3;
        noteField.font = [NBSettings cellFont];
        noteField.textColor = [UIColor blueColor];
        noteField.layer.borderWidth = 1.0f;
        noteField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        noteField.backgroundColor = [UIColor whiteColor];
        noteField.editable = YES;
        noteField.allowsEditingTextAttributes = YES;
        [noteField setReturnKeyType:UIReturnKeyDefault];
        [noteField setDelegate:self];
        [[self contentView] addSubview:noteField];
    }
    return self;
}

// Delegate: Check if Edit enabled (May be View Only mode)
- (BOOL)textViewShouldBeginEditing:(UITextView *)noteField
{   //NSLog(@"NotesCell: textViewShouldBeginEditing");
    return([NBSettings editFlag]);
}

+ (NSString *)identifier
{
    return @"StringCell";
}
// Set Current Value in Note Field
- (void)updateValues
{   //NSLog(@"NotesCell: updateValues");
    [super updateValues];
    if ([NBSettings isPhone])
        [[self labelField] setText:@"Notes             (Click here to Save)"];
    [noteField setText:[[self data] stringValue]];
}
// Handle touch outside of Note Field
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"NotesCell: touchesBegan");
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != noteField) {
        [noteField endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
// Delegate: End Editing method Save New Value
- (void)textViewDidEndEditing:(UITextView *)textView
{   //NSLog(@"NotesCell: textViewDidEndEditing");
    [[self data] setStringValue:[noteField text]];
}
+ (CGFloat)cellHeight
{   if ([NBSettings isPhone])
        return 100.0 + CELL_PADDING;
    return 102.0 + (CELL_PADDING * 2);
}
@end
