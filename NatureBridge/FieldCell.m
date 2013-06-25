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
#import "NBSettings.h"

@implementation FieldCell

@synthesize field;
@synthesize data;
@synthesize labelField;
@synthesize unitField;
@synthesize labelFrame;
@synthesize inputFrame;
@synthesize notesFrame;
@synthesize sliderFrame;
@synthesize numberFrame;
@synthesize unitFrame;
@synthesize numberArrowInsets;
@synthesize listArrowInsets;

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
    
    // iPhone use a double line format
    if ([NBSettings isPhone]) {
        if ([NBSettings isLandscape]) { // WIDTH 460
            labelFrame = CGRectMake(5,0,450,25);
            inputFrame = CGRectMake(155,25,265,25);
            notesFrame = CGRectMake(155,25,265,75);
            sliderFrame = CGRectMake(155,25,160,25);
            numberFrame = CGRectMake(260,25,110,25);
            unitFrame = CGRectMake(375,25,75,25);
        } else {                        // WIDTH 300
            labelFrame = CGRectMake(5,0,290,25);
            inputFrame = CGRectMake(25,25,265,25);
            notesFrame = CGRectMake(25,25,265,75);
            sliderFrame = CGRectMake(25,25,160,25);
            numberFrame = CGRectMake(125,25,110,25);
            unitFrame = CGRectMake(240,25,60,25); }
        numberArrowInsets = UIEdgeInsetsMake(5,90,5,5);
        listArrowInsets = UIEdgeInsetsMake(5,245,5,5);
    // iPad use a single line format
    } else {
        if ([NBSettings isLandscape]) { // WIDTH 934
            labelFrame = CGRectMake(10,10,504,34);
            inputFrame = CGRectMake(524,10,320,34);
            notesFrame = CGRectMake(524,10,320,102);
            sliderFrame = CGRectMake(524,10,260,34);
            numberFrame = CGRectMake(524,10,120,34);
            unitFrame = CGRectMake(854,10,70,34);
        } else {                        // WIDTH 678
            labelFrame = CGRectMake(10,10,248,34);
            inputFrame = CGRectMake(268,10,320,34);
            notesFrame = CGRectMake(268,10,320,102);
            sliderFrame = CGRectMake(268,10,260,34);
            numberFrame = CGRectMake(268,10,120,34);
            unitFrame = CGRectMake(598,10,70,34); }
        numberArrowInsets = UIEdgeInsetsMake(10,100,10,10);
        listArrowInsets = UIEdgeInsetsMake(10,300,10,10);
    }
/*    NSLog(@"FieldCell: labelFrame: %@",NSStringFromCGRect(labelFrame));
    NSLog(@"FieldCell: inputFrame: %@",NSStringFromCGRect(inputFrame));
    NSLog(@"FieldCell: notesFrame: %@",NSStringFromCGRect(notesFrame));
    NSLog(@"FieldCell: sliderFrame: %@",NSStringFromCGRect(sliderFrame));
    NSLog(@"FieldCell: unitFrame: %@",NSStringFromCGRect(unitFrame)); */
    [self.labelField setFrame:labelFrame];
    [self.unitField setFrame:unitFrame];
}

+ (CGFloat)cellHeight
{   if ([NBSettings isPhone]) return 55;
    return 54.0;
}

- (id)initWithField:(Field *)newField forObservation:(Observation *)observation
{   //NSLog(@"FieldCell: initWithField");
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
    if (self){
        [self setField:newField];
        [self setObservation:observation];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self setLabelField:[[UILabel alloc] init]];
        labelField.tag = 1;
        labelField.font = [NBSettings cellFont];
        labelField.textColor = [UIColor blackColor];
        labelField.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:labelField];
        
        [self setUnitField:[[UILabel alloc] init]];
        unitField.tag = 2;
        unitField.font = [NBSettings cellFont];
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
- (int)displayInput:(UIView *)view;
{   // See Specific Cell Types
    return(0);
}
- (CGSize)displayInputForm:(UIView *)view {
    // See Specific Cell Type
    CGSize size = CGSizeMake(315,240);
    return(size);
}
- (void)saveValue:(UIView *)view;
{   // See Specific Cell Types
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
