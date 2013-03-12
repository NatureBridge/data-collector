//
//  NotesCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/20/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "NotesCell.h"

#define NUM_LINES 3

@implementation NotesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (CGFloat)cellHeight
{
    return (34.0*NUM_LINES) + (CELL_PADDING * 2);
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
