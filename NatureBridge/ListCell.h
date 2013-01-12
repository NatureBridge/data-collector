//
//  ListCell.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/11/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//
#import "FieldCell.h"

@interface ListCell : FieldCell <UIActionSheetDelegate>
{
}
@property NSArray *options;
@property UIButton *button;
@end
