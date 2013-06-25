//
//  LocationCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "LocationCell.h"
#import "Value.h"
#import "ObservationViewController.h"
#import "Station.h"
#import "NBSettings.h"
#import "NBGeoLocation.h"
#import "LocationCellDelegate.h"

@implementation LocationCell

static id <LocationCellDelegate> caller;
static double lat;
static double lon;
static UIButton *editBtn;
static UIActionSheet *actionSheet;
static UILabel *latLabel;
static UILabel *longLabel;
static UIButton *saveBtn;
static UIPickerView *latPicker;
static UIPickerView *lonPicker;

// Get Location Method
- (void) getLocation:(id)byObject toRect:(CGRect)rect   //toField:(UIButton *)toField
              curLat:(double)curLat curLon:(double)curLon
{   //NSLog(@"LocationCell: getLocation: %@ %f %f %@",
    //      [byObject class],curLat,curLon,NSStringFromCGRect(rect));
    caller = byObject;
    lat = curLat;
    lon = curLon;
    [self layoutSubviews];
    [self updateValues];
    [self onEditClick:rect];
}
// Layout Subviews
- (void)layoutSubviews
{   //NSLog(@"LocationCell: layoutSubViews.");
    [super layoutSubviews];
    latLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(5,10,110,30)];
    [latLabel setText:@"Latitude"];
    [latLabel setBackgroundColor:[UIColor lightGrayColor]];
    [latLabel setTextAlignment:NSTextAlignmentRight];
    [latLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    longLabel = [[UILabel alloc]
                 initWithFrame:CGRectMake(195,10,110,30)];
    [longLabel setText:@"Longitude"];
    [longLabel setBackgroundColor:[UIColor lightGrayColor]];
    [longLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveBtn setFrame:CGRectMake(125,10,60,30)];
    [saveBtn setTitle:@"Save" forState:0];
    [saveBtn addTarget:self action:@selector(onSaveClick:)
            forControlEvents:UIControlEventTouchUpInside];
    CGRect latRect = CGRectMake(5,50,150,300);
    latPicker = [[UIPickerView alloc] initWithFrame:latRect];
    [latPicker setDataSource:self];
    [latPicker setDelegate:self];
    latPicker.showsSelectionIndicator = YES;
    CGRect longRect = CGRectMake(155,50,150,300);
    lonPicker = [[UIPickerView alloc] initWithFrame:longRect];
    [lonPicker setDataSource: self];
    [lonPicker setDelegate: self];
    lonPicker.showsSelectionIndicator = YES;
}
// Update Edit Button Text and Picker Values
- (void)updateValues
{   //NSLog(@"LocationCell: updateValues.");
//    [super updateValues];
    [self setPicker:latPicker value:lat];
    [self setPicker:lonPicker value:lon];
    NSString *text =
        [NBGeoLocation textLatitude:lat andLongitude:lon];
    if (editBtn)
        [editBtn setTitle:text forState:UIControlStateNormal];
    //NSLog(@"LocationCell: editBtn: %@",editBtn.titleLabel.text);

}
// Add Button to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if ((self) && (editBtn)) {
        [[self contentView] addSubview:editBtn];
    }
    return self;
}
// Respond to Edit Button click - Popup Action Sheet
- (IBAction)onEditClick:(CGRect)rect 
{   //NSLog(@"LocationCell: onEditClick.");
    // XXXX   locationBtn = sender;
    //Check if Edit enabled (May be View Only mode)
    //if (![NBSettings editFlag]) return;
    // iPhone: Display Action Sheet at bottom
    if ([NBSettings isPhone]) {
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
            delegate:self cancelButtonTitle:nil
            destructiveButtonTitle:nil otherButtonTitles:nil];
        // Display Input Form
        [self displayInputForm:actionSheet];
        [actionSheet setBackgroundColor:[UIColor lightGrayColor]];
        [actionSheet showFromRect:rect
                 inView:caller.view animated:YES];
        //NSLog(@"LocationCell: onEditClick: iPhone done.");
    // iPad: Popup Window for Action Sheet
    } else {
        //NSLog(@"LocationCell: onEditClick: iPad.");
        [caller displayPopup:self rect:rect
                      arrow:UIPopoverArrowDirectionUp];
        //NSLog(@"LocationCell: onEditClick: iPad done.");
    }
}
// Display Input Form: Fields and Rollers in View
- (CGSize)displayInputForm:(UIView *)view
{   //NSLog(@"LocationCell: displayInputForm.");
    [view addSubview:latLabel];
    [view addSubview:longLabel];
    [view addSubview:saveBtn];
    [view addSubview:latPicker];
    [view addSubview:lonPicker];
    [self setPicker:latPicker value:lat];
    [self setPicker:lonPicker value:lon];
    CGSize size = CGSizeMake(315,280);
    return(size);
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //NSLog(@"LocationCell: numberOfComponents. 3");
    return(3);
}
- (CGFloat)pickerView:(UIPickerView *)picker widthForComponent:(NSInteger)component{
    CGFloat width;
    if (component == 0)
        if (picker == lonPicker)   width = 55.0;
        else                        width = 45.0;
        else                        width = 30.0;
    //NSLog(@"LocationCell: widthForComponent: %d %f",component,width);
    return(width);
}
- (NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{   NSInteger middle, num;
    if (picker == latPicker) middle = 90;
    else                     middle = 180;
    if (component == 0) num = middle + middle;
    else                num = 60;
    //NSLog(@"LocationCell: numberOfRowsInComponent: %d %d",component,num);
    return(num);
}
- (UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text;
    char less, more;
    UILabel *label = (UILabel*)view;
    NSInteger middle;
    if(!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:16];
    }
    if (picker == latPicker)  {middle=90;  less='S'; more='N';}
    else                      {middle=180; less='E'; more='W';}
    switch(component) {
        case 0 :
            if (row < middle) {
                text = [NSString stringWithFormat:@"%d°%c",middle - row - 1,less];
            } else {
                text = [NSString stringWithFormat:@"%d°%c",row - middle,more];
            } break;
        case 1 :
            text = [NSString stringWithFormat:@"%d'",row];
            break;
        case 2:
            text = [NSString stringWithFormat:@"%d\"",row];
            break;
        default :
            text = @"";
            break;
    }label.text = text;
    //NSLog(@"LocationCell: titleForRow: %d %d %@",component,row,label.text);
    return(label);
}
- (void) onSaveClick:(id)sender
{   //NSLog(@"LocationCell: onSaveClick:");
    lat = [self getPicker:latPicker];
    lon = [self getPicker:lonPicker];
    [self updateValues];
    // iPhone: Dismiss Action Sheet at bottom
    if ([NBSettings isPhone])
        [actionSheet dismissWithClickedButtonIndex:0 animated:NO];
    // iPad: Dismiss Popup Window
    else
        [caller dismissPopup];
    // Return Location via Delegate method
    [caller setInputLocation:lat lon:lon];
}
- (void)actionSheet:(UIActionSheet *)actionSheet
            clickedButtonAtIndex:(NSInteger)index
{   //NSLog(@"LocationCell: clickedButton: %d",index);

}
- (void)setPicker:(UIPickerView *)picker value:(double)value {
    double num, rem;
    int middle, row0, row1, row2;
    if (picker == latPicker) middle = 90;
    else                     middle = 180;
    if (value < 0)  {num = -value;  row0 = (middle-1) - (int)num;}
    else            {num = value;   row0 = (int)num + middle;}
    rem = fmod(num,1) + 0.00014; //Round up to nearest sec
    row1 = (int)(rem * 60);
    row2 = (int)(rem * 3600) - row1*60;
    [picker selectRow:row0 inComponent:0 animated:NO];
    [picker selectRow:row1 inComponent:1 animated:NO];
    [picker selectRow:row2 inComponent:2 animated:NO];
    //NSLog(@"LocationCell: setPicker: %d,%d,%d: %f",row0,row1,row2,value);
}
- (double)getPicker:(UIPickerView *)picker {
    int middle, row0, row1, row2;
    row0 = [picker selectedRowInComponent:0];
    row1 = [picker selectedRowInComponent:1];
    row2 = [picker selectedRowInComponent:2];
    if (picker == latPicker) middle = 90;
    else                     middle = 180;
    double value = row0 - middle;
    double rem = (row1 / 60.0) + (row2 / 3600.0);
    if (value < 0) rem = - rem+1;
    value += rem;
    //NSLog(@"LocationCell: getPicker: %d,%d,%d: %f",row0,row1,row2,value);
    return(value);
}
+ (NSString *)identifier {
    return @"LocationCell";
}
@end