//
//  NumericPadViewController.h
//  NatureBridge
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <UIKit/UIKit.h>

@interface NumericPadViewController : UIViewController {
    IBOutlet UILabel *valueFld;
    IBOutlet UILabel *unitsFld;
    NSMutableString *value;
    NSString *units;
    NSNumber *min;
    NSNumber *max;
}
-(IBAction) digit0:(id *)sender;
-(IBAction) digit1:(id *)sender;
-(IBAction) digit2:(id *)sender;
-(IBAction) digit3:(id *)sender;
-(IBAction) digit4:(id *)sender;
-(IBAction) digit5:(id *)sender;
-(IBAction) digit6:(id *)sender;
-(IBAction) digit7:(id *)sender;
-(IBAction) digit8:(id *)sender;
-(IBAction) digit9:(id *)sender;
-(IBAction) minus:(id *)sender;
-(IBAction) point:(id *)sender;
-(IBAction) back:(id *)sender;
-(IBAction) save:(id *)sender;

@property (nonatomic,retain) UILabel *valueFld;
@property (nonatomic,retain) UILabel *unitsFld;
@property (nonatomic,retain) NSMutableString *value;
@property (nonatomic,retain) NSString *units;
@property (nonatomic,retain) NSNumber *min;
@property (nonatomic,retain) NSNumber *max;
@end
