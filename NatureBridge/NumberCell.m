//
//  NumberCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NumberCell.h"
#import "ObservationViewController.h"
#import "NBSettings.h"
#import "NBRange.h"

@implementation NumberCell

@synthesize button;

static UIActionSheet *actionSheet;
static NSMutableString *number;
static UILabel *value;
static UILabel *units;

// Layout Subviews
- (void)layoutSubviews
{   //NSLog(@"NumberCell: layoutSubviews.");
    [super layoutSubviews];
    [[self button] setFrame:[self numberFrame]];
    UIImage *arrow = [UIImage imageNamed:@"arrow"];
    [button setImage:arrow forState:UIControlStateNormal];
    [button setImageEdgeInsets:[self numberArrowInsets]];
    number = [[NSMutableString alloc] initWithCapacity:10];
}

// Set Current Button Value
- (void)updateValues
{   //NSLog(@"NumberCell: updateValues.");
    [super updateValues];
    NSString *value = [[self data] stringValue];
    [button setTitle:value forState:UIControlStateNormal];
    //NSLog(@"NumberCell: updateValues. value: %@",value);
}

// Add Button to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if (self) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = 3;
        button.titleLabel.font = [NBSettings cellFont];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [button addTarget:self action:@selector(editCell:) forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:button];
    }
    return self;
}
// Respond to Edit Cell click - Popup Action Sheet
- (IBAction)editCell:(UIButton *)sender
{   //NSLog(@"NumberCell: editCell.");
    //Check if Edit enabled (May be View Only mode)
    if (![NBSettings editFlag])
        return;
    // iPhone: Display Action Sheet at bottom
    if ([NBSettings isPhone]) {
        NSString *title = @" \n\n\n\n\n\n\n\n\n\n\n\n";
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
            delegate:self cancelButtonTitle:nil
            destructiveButtonTitle:nil otherButtonTitles:nil];
        // Display Input Form
        [self displayInputForm:actionSheet];
        [actionSheet setBackgroundColor:[UIColor lightGrayColor]];
        [actionSheet showInView:sender.superview];
    // iPad: Popup Window for Action Sheet
    } else {
        [(ObservationViewController *)self.superview.nextResponder
         displayPopup:self rect:sender.frame
         arrow:UIPopoverArrowDirectionLeft];
    }
}
// Display Input Form (Numeric Pad) in Action Sheet
- (CGSize)displayInputForm:(UIView *)view
{   //NSLog(@"NumberCell: displayInput.");
    NSArray *names = [[NSArray alloc] initWithObjects:
                      @"7",@"8",@"9",@"-",
                      @"4",@"5",@"6",@"Back",
                      @"1",@"2",@"3",@"Save",
                      @"0",@".",nil];
    //iPhone: {{X, Y},{W  ,H}} Width 315
    NSArray *rects = [[NSArray alloc] initWithObjects:
             @"{{10,55},{70,40}}", @"{{85,55},{70,40}}", @"{{160,55},{70,40}}", @"{{235,55},{70,40}}",
             @"{{10,100},{70,40}}",@"{{85,100},{70,40}}",@"{{160,100},{70,40}}",@"{{235,100},{70,40}}",
             @"{{10,145},{70,40}}",@"{{85,145},{70,40}}",@"{{160,145},{70,40}}",@"{{235,145},{70,85}}",
             @"{{10,190},{145,40}}",                     @"{{160,190},{70,40}}",nil];
    NSString *data = [[self data] stringValue];
    if (data == nil) data = @"";
    [number setString:data];
    value = [[UILabel alloc]initWithFrame:CGRectMake(10,10,170,35)];
    [value setText:number];
    [value setFont:[UIFont boldSystemFontOfSize:32.0]];
    [value setTextAlignment:NSTextAlignmentRight];
    [view addSubview:value];
    units = [[UILabel alloc] initWithFrame:CGRectMake(185,10,120,35)];
    [units setText:[self.field units]];
    [units setFont:[UIFont boldSystemFontOfSize:32.0]];
    [view addSubview:units];
    UIButton *btn;
    for (int n=0; n<14; n++) {
        btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectFromString([rects objectAtIndex:n])];
        [btn setTitle:[names objectAtIndex:n] forState:0];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:26.0];
        [btn addTarget:self action:@selector(numClick:)
            forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    CGSize size = CGSizeMake(315,240);
    return(size);
}
// Respond to Number & Control click - Update Value
- (void) numClick:(id)sender {
    NSString *btnText = ((UIButton*)sender).currentTitle;
    //NSLog(@"NumberCell: click %@",btnText);
    char c = [btnText characterAtIndex:0];
    if ((c == '-') && (number.length < 1))
        [number setString:@"-"];
    if ((c >= '0') && (c <= '9'))
        [number appendString:btnText];
    if ((c == '.') && ([number rangeOfString:@"."].location == NSNotFound))
        [number appendString:@"."];
    if ((c =='B') && (number.length > 0))
        [number setString:[number substringToIndex:(number.length-1)]];
    value.text = number;
    value.backgroundColor = [UIColor whiteColor];
    if (c == 'S') {
        if (number.length >0) { // Range Check Number Input
            NSNumber *num = [[NSNumber alloc] initWithFloat:[number floatValue]];
            NSNumber *min = [[self field] minimum];
            NSNumber *max = [[self field] maximum];
            NSString *msg = [NBRange check:num min:min max:max];
            if (msg != nil) {
                if ([NBSettings isPhone]) {
                    value.text = msg;
                    value.backgroundColor = [UIColor redColor];
                }return;
            }
        } // Save Input Value
        [button setTitle:number forState:UIControlStateNormal];
        NSString *data = [[NSString alloc] initWithString:number];
        [[self data] setStringValue:data];
        //NSLog(@"NumberCell: number:%@",number);
        // iPhone: Dismiss Action Sheet
        if ([NBSettings isPhone])
            [actionSheet dismissWithClickedButtonIndex:99 animated:YES];
        // iPad: Dismiss Popup Window
        else
            [(ObservationViewController *)self.superview.nextResponder dismissPopup];

    }
}
+ (NSString *)identifier
{
    return @"NumberCell";
}
@end
