//
//  NBLog.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <UIKit/UIKit.h>

@interface NBLog:NSObject <UIActionSheetDelegate,NSCoding>
{
    NSString *logName;                // Log Name.
    NSMutableString *logText;         // Log Text expansible data.
}
-(void) create:(NSString *)name in:(UITextView *)textView;
-(void) add:(NSString *)text;
-(void) header:(NSString *)text;
-(void) data:(NSString *)text;
-(void) close;
-(void) listLogs:(UIView *)view in:(UITextView *)textView;
+(void) archive;
+(void) restore;
-(void) encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

@property NSString *logName;
@property NSMutableString *logText;
#define logFileName @"TransmitLog.txt"
#define logMax 10

@end