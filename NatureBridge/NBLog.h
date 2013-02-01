//
//  NBLog.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/18/13.
//  Copyright (c) 2013 Richard F Emmett All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NBLog:NSObject <UIActionSheetDelegate,NSCoding>
{
    NSString *logName;                // Log Name.
    NSMutableString *logText;         // Log Text expansible data.
}
-(void) start:(UITextView *)logView;
-(void) create:(NSString *)name;
-(void) add:(NSString *)text;
-(void) header:(NSString *)text;
-(void) error:(NSString *)text;
-(void) response:(NSString *)text;
-(void) listLogs:(UIView *)view;
+(void) getFileName;
+(void) archive;
+(void) restore;
-(void) encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

@property NSString *logName;
@property NSMutableString *logText;
#define logFileName @"TransmitLog.txt"
#define logMax 10

@end