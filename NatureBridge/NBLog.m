//
//  NBLog.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NBLog.h"

@implementation NBLog
@synthesize logName;
@synthesize logText;

static NSMutableArray* logTbl;  // Table of Transmit Logs
static UITextView *textView;    // TextView Object to display log.
static NSString* logFile;       // File to Archive Transmit Logs

//
// CREATE A NEW LOG
//
// Create Log, add DateTimestamp to log name, and display it.
-(void) create:(NSString *)name  in:(UITextView *)textFld
{
    logName = [NSString stringWithFormat:@"%@ %@",name,[NBLog getDateTime]];
    if (textView == nil) {
        textView = textFld;
    } else {
        return; // Log is busy !
    }
    
    logText = [[NSMutableString alloc] initWithCapacity:1000];
    if ([logTbl count] >= logMax) {
        [logTbl removeObjectAtIndex:logMax-1];
    }
    
    [logTbl insertObject:self atIndex:0];
    [self add:logName];
}

// Add header to log and scroll to bottom
-(void) header:(NSString *)text
{
    [self add:[NSString stringWithFormat:@"\n%@",text]];
}

// Add data line to log and scroll to bottom
-(void) data:(NSString *)text
{
    [self add:[NSString stringWithFormat:@"\t%@",text]];
}

// Add text to log and scroll to bottopm
-(void) add:(NSString *)text
{
    [logText appendFormat:@"%@\n",text];
    textView.text = logText;
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
}

// Close log
-(void) close
{
    textView = nil;
    [NBLog archive]; // AppDelegate Terminate is not reliable
}

// getDateTime in format: yyyy-MM-dd HH:mm:ss
+ (NSString *) getDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//
// REVIEW PAST LOGS
//
// Respond to List Button Click - List Logs in Popup Action Sheet
-(void)listLogs:(UIView *)view in:(UITextView *)textFld
{
    if (textView == nil) {
        textView = textFld;
    } else {
        return; // Log is busy !
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (NBLog *log in logTbl) {
        [actionSheet addButtonWithTitle:log.logName];
    }
    [actionSheet showInView:view];
}

// Respond to Log List Action Sheet Button Click Display Log
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >=0 && buttonIndex < [logTbl count]) {
        NBLog *log = [logTbl objectAtIndex:buttonIndex];
        textView.text = log.logText;
    }
    textView = nil;
}

//
// PERSIST LOGS
//
// Save Logs to Archive - Called from AppDelegate Terminate
+(void) archive
{
    if (logFile == nil) {
        [self getFileName];
    }
    [NSKeyedArchiver archiveRootObject:logTbl toFile:logFile];
}

// Restore Logs from Archives- Called from AppDelegate Launch
+(void) restore
{
    if (logFile == nil) {
        [self getFileName];
    }
    if (logTbl == nil) {
        logTbl = [NSKeyedUnarchiver unarchiveObjectWithFile:logFile];
    }
    if (logTbl == nil) {
        logTbl = [[NSMutableArray alloc] initWithCapacity:logMax];
    }
}

// Dump Logs Diagnostic
+(void) dump
{
    for (int i=0; i<[logTbl count]; i++) {
        NBLog *log = (NBLog *)[logTbl objectAtIndex:i];
        NSLog(@"NBLog: Log: %@",log.logText);
    }
}

// Encode Log for Archiving
-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.logName forKey:@"Name"];
    [encoder encodeObject:self.logText forKey:@"Text"];
}

// Decode Log from Archive
-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.logName = [decoder decodeObjectForKey:@"Name"];
        self.logText = [decoder decodeObjectForKey:@"Text"];
    }
    return(self);
}

// Get FilenName for Archive
+(void) getFileName
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    logFile = [cacheDir stringByAppendingPathComponent:logFileName];
}

@end