//
//  FieldCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FieldCell.h"

@implementation FieldCell

@synthesize field;
@synthesize labelField;
@synthesize unitField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"super %@: %f-%f, %f-%f", self.field.label, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

    [self.labelField setFrame:CGRectMake(5.0, 5.0, 240.0, self.frame.size.height - 10.0)];
    [self.unitField setFrame:CGRectMake(self.contentView.frame.size.width - 75.0, 5.0, 50.0, self.frame.size.height - 10.0)];
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

- (id)initWithField:(Field *)newField
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
    if (self){
        [self setField:newField];
        
        [self setLabelField:[[UILabel alloc] init]];
        labelField.tag = 1;
        labelField.font = [UIFont systemFontOfSize:17.0];
        labelField.textColor = [UIColor blackColor];
        labelField.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:labelField];
        
        [self setUnitField:[[UILabel alloc] init]];
        unitField.tag = 2;
        unitField.font = [UIFont systemFontOfSize:17.0];
        unitField.textColor = [UIColor blackColor];
        unitField.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:unitField];
    }
    return self;
}

- (void)updateValues
{
    [[self labelField] setText:[field label]];
    [[self unitField] setText:[field units]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifier
{
    return @"GenericFieldCell";
}

@end
