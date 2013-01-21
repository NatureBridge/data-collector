//
//  NBLog.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/18/13.
//  Copyright (c) 2013 Richard F Emmett All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NBLog:NSObject
{
    NSString *logName;                // Log Name.
    NSMutableString *logText;         // Log Text expansible data.
    UITextView *textView;             // TextView Object to display log.
}
-(void) create:(UITextView *)logView name:(NSString *)name;
-(void) add:(NSString *)text;
-(void) header:(NSString *)text;
-(void) error:(NSString *)text;
-(void) response:(NSString *)text;
@end