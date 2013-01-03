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
    
    [self.labelField setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 4, self.frame.size.height - CELL_PADDING * 2)];
    [self.unitField setFrame:CGRectMake(self.contentView.frame.size.width - UNIT_WIDTH - CELL_PADDING, CELL_PADDING, UNIT_WIDTH, self.frame.size.height - CELL_PADDING * 2)];
}

+ (CGFloat)cellHeight
{
    return 34.0 + CELL_PADDING * 2;
}

- (id)initWithField:(Field *)newField
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
    if (self){
        [self setField:newField];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        
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
