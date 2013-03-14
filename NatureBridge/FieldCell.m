//
//  FieldCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FieldCell.h"
#import "FSObservationData.h"

@implementation FieldCell

@synthesize field;
@synthesize data;
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
    
    [self.labelField setFrame:CGRectMake(CELL_PADDING,
                                         CELL_PADDING,
                                         self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 4,
                                         self.frame.size.height - CELL_PADDING * 2)];
    
    [self.unitField setFrame:CGRectMake(self.contentView.frame.size.width - UNIT_WIDTH - CELL_PADDING,
                                        CELL_PADDING,
                                        UNIT_WIDTH,
                                        self.frame.size.height - CELL_PADDING * 2)];
}

+ (CGFloat)cellHeight
{
    return 34.0 + CELL_PADDING * 2;
}

- (id)initWithField:(Field *)newField forObservation:(Observation *)observation
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
    if (self){
        [self setField:newField];
        [self setObservation:observation];
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
    [self setData:[FSObservationData findOrCreateFor:[self observation] withField:[self field]]];
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
