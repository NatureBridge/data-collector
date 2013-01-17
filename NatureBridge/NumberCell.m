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

- (IBAction)valueChanged:(UITextField *)sender
{
    [[self data] setNumberValue:[NSNumber numberWithDouble:[sender.text doubleValue]]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.numberField setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                          CELL_PADDING,
                                          INPUT_WIDTH,
                                          self.frame.size.height - CELL_PADDING * 2.0)];
}

- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
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
        [numberField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [[self contentView] addSubview:numberField];
    }
    return self;
}

- (void)updateValues
{
    [super updateValues];
    
    [numberField setText:[NSString stringWithFormat:@"%@", [[self data] numberValue]]];
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
