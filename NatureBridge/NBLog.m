//
//  NBLog.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/18/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//
#import "NBLog.h"

@implementation NBLog
@synthesize logName;
@synthesize logText;

static NSMutableArray* logTbl;  // Table of Transmit Logs
static UITextView *textView;    // TextView Object to display log.
static NSString* logFile;       // File to Archive Transmit Logs

// Save TextView Field to display log Data
-(void) start:(UITextView *)logView {
    textView = logView;
}
// Create Log, add DateTimestamp to log name, and display it.
-(void) create:(NSString *)name {
    logName = [NSString stringWithFormat:@"%@ %@",name,[self getDateTime]];
    //NSLog(@"NBLog: create: %@",logName);
    logText = [[NSMutableString alloc] initWithCapacity:1000];
    if ([logTbl count] >= logMax)
        [logTbl removeObjectAtIndex:logMax-1];
    [logTbl insertObject:self atIndex:0];
    //NSLog(@"NBLog: create: %i",[logTbl count]);
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
// Respond to List Button Click - List Logs in Popup Action Sheet
- (void)listLogs:(UIView *)view
{   //NSLog(@"NBLog: listLogs.");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
        initWithTitle:nil delegate:self cancelButtonTitle:nil
        destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NBLog *log in logTbl) {
        [actionSheet addButtonWithTitle:log.logName];
    }
    [actionSheet showInView:view];
}
// Respond to Log List Action Sheet Button Click Display Log
- (void)actionSheet:(UIActionSheet *)actionSheet
        clickedButtonAtIndex:(NSInteger)buttonIndex
{   //NSLog(@"NBLog: clickedButtonAtIndex: %d",buttonIndex);
    NBLog *log = [logTbl objectAtIndex:buttonIndex];
    textView.text = log.logText;
}
// getDateTime in format: yyyy-MM-dd HH:mm:ss
- (NSString *) getDateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD HH:mm:SS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
// Get FilenName for Logs in Arcghive
+(void) getFileName{
    NSString *cacheDir =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
            NSUserDomainMask, YES) objectAtIndex:0];
    logFile = [cacheDir stringByAppendingPathComponent:logFileName];
}
// Save Logs to Archive
+(void) archive{
    //NSLog(@"NBLog: archive: %@",logFileName);
    [NSKeyedArchiver archiveRootObject:logTbl toFile:logFile];
}
// Restore Logs from Archives
+(void) restore{
    if (logFile == nil) [self getFileName];
    //NSLog(@"NBLog: restore: %@",logFileName);
    if (logTbl == nil)
        logTbl = [NSKeyedUnarchiver unarchiveObjectWithFile:logFile];
    if (logTbl == nil)
        logTbl = [[NSMutableArray alloc] initWithCapacity:logMax];
/*    for (int i=0; i<[logTbl count]; i++) {
        NBLog *log = (NBLog *)[logTbl objectAtIndex:i];
        NSLog(@"NBLog: Log: %@",log.logText); } */
}
// Encode Log for Archiving
-(void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.logName forKey:@"Name"];
    [encoder encodeObject:self.logText forKey:@"Text"];
}
// Decode Log from Archive
-(id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.logName = [decoder decodeObjectForKey:@"Name"];
        self.logText = [decoder decodeObjectForKey:@"Text"]; }
    return(self);
}
@end