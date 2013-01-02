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
    
    [self.stringField setFrame:CGRectMake(250.0, 5.0, 320.0, self.frame.size.height - 10.0)];
}

- (id)initWithField:(Field *)field
{
    self = [super initWithField:field];
    if(self) {
        // Initialization code
                
        [self setStringField:[[UITextField alloc] init]];
        stringField.tag = 3;
        stringField.font = [UIFont systemFontOfSize:17.0];
        stringField.textColor = [UIColor blueColor];
        stringField.borderStyle = UITextBorderStyleBezel;
        stringField.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:stringField];
    }
    return self;
}

+ (NSString *)identifier
{
    return @"StringCell";
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
