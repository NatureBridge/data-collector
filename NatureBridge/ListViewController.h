//
//  ListViewController.h
//  NatureBridge
//
//  Created by Richard F Emmett on 2/4/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UIActionSheetDelegate>
{
    NSArray *optionLst;
    NSString *text;
    NSString *value;
}
- (void)load:(NSArray *)options;

@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *value;
@end
