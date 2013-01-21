//
//  NBLog.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/18/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//
#import "NBLog.h"

@implementation NBLog

// Create Log, add DateTimestamp to log name, and display it.
-(void) create:(UITextView *)logView name:(NSString *)name {
    logName = [NSString stringWithFormat:@"%@ %@",name,[self getDateTime]];
    logText = [[NSMutableString alloc] initWithCapacity:1000];
    textView = logView;
    [self add:logName];
}

// Add header to log and scroll to bottopm
-(void) header:(NSString *)text {
    [self add:[NSString stringWithFormat:@"\n%@",text]];
}


// Add Error text to log
-(void) error:(NSString *)text {
    [self add:[NSString stringWithFormat:@"\tError: %@",text]];
}

// Add Response text to log
-(void) response:(NSString *)text {
    [self add:[NSString stringWithFormat:@"\tResponse: %@",text]];
}

// Add text to log and scroll to bottopm
-(void) add:(NSString *)text {
    [logText appendFormat:@"%@\n",text];
    textView.text = logText;
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
}

// getDateTime in format: yyyy-MM-dd HH:mm:ss
- (NSString *) getDateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD HH:mm:SS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end