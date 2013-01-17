//
//  StringCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "StringCell.h"

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
        [self setStringField:[[UITextField alloc] init]];
        stringField.tag = 3;
        stringField.font = [UIFont systemFontOfSize:17.0];
        stringField.textColor = [UIColor blueColor];
        stringField.borderStyle = UITextBorderStyleBezel;
        stringField.backgroundColor = [UIColor clearColor];
        [stringField setReturnKeyType:UIReturnKeyDone];
        [stringField setDelegate:self];
        [[self contentView] addSubview:stringField];
    }
    return self;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[self data] setStringValue:[textField text]];
    
    if ([[[self field] label] isEqualToString:@"School/Organization Name"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[textField text] forKey:@"FSSchool"];
    }

    return YES;
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
