//
//  NumberCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "NumberCell.h"

@implementation NumberCell

@synthesize numberField;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.numberField setFrame:CGRectMake(250.0, 5.0, 320.0, self.frame.size.height - 10.0)];
}

- (id)initWithField:(Field *)field
{
    self = [super initWithField:field];
    if(self) {
        // Initialization code
        
        [self setNumberField:[[UITextField alloc] init]];
        numberField.tag = 3;
        numberField.font = [UIFont systemFontOfSize:17.0];
        numberField.textColor = [UIColor blueColor];
        numberField.borderStyle = UITextBorderStyleBezel;
        numberField.backgroundColor = [UIColor clearColor];
        numberField.keyboardType = UIKeyboardTypeNumberPad;
        numberField.autocorrectionType = UITextAutocorrectionTypeNo;
        numberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [[self contentView] addSubview:numberField];
    }
    return self;
}

+ (NSString *)identifier
{
    return @"NumberCell";
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
