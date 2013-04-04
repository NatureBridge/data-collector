//
//  StationCreateController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 3/10/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "StationCreateController.h"
#import "FSProjects.h"
#import "FSStations.h"
#import "FSStore.h"

@implementation StationCreateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Create a new location"];
        latDeg = 47;
        latMin = 58;
        latSec = 10;
        lonDeg = -123;
        lonMin = 29;
        lonSec = 55;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onSave)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    latPicker = [[UIPickerView alloc] init];
    [latPicker setDataSource:self];
    [latPicker reloadAllComponents];
    [latPicker selectRow:89 - latDeg inComponent:0 animated:NO];
    [latPicker selectRow:latMin inComponent:1 animated:NO];
    [latPicker selectRow:latSec inComponent:2 animated:NO];
    [latPicker setDelegate:self];
    [latitudeField setInputView:latPicker];
    [latitudeField setDelegate:self];
    
    lonPicker = [[UIPickerView alloc] init];
    [lonPicker setDataSource:self];
    [lonPicker reloadAllComponents];
    [lonPicker selectRow:lonDeg + 179 inComponent:0 animated:NO];
    [lonPicker selectRow:lonMin inComponent:1 animated:NO];
    [lonPicker selectRow:lonSec inComponent:2 animated:NO];
    [lonPicker setDelegate:self];
    [longitudeField setInputView:lonPicker];
    [longitudeField setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLatLonFields];
}

- (void) onSave
{
    double lat = latDeg + (latMin / 60.0) + (latSec / 3600.0);
    double lon = lonDeg + (lonMin / 60.0) + (lonSec / 3600.0);
    
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:[FSStations tableName]
                                            inManagedObjectContext:[[FSStore dbStore] context]];
    [station setName:[nameField text]];
    [station setLatitude:lat andLongitude:lon];
    [station setProject:[FSProjects currentProject]];
    
    if([[station name] length] == 0) {
        [station setName:[NSString stringWithFormat:@"ø %@", [station prettyLocation]]];
    }
    
    [[FSStore dbStore] saveChanges];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return pickerView == latPicker ? 180 : 360;
    } else {
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger middle = pickerView == latPicker ? 90 : 180;
    switch(component) {
        case 0 :
            if (row < middle) {
                return [NSString stringWithFormat:@"%d°%@", middle - row - 1, pickerView == latPicker ? @"N" : @"W"];
            } else {
                return [NSString stringWithFormat:@"%d°%@", row - middle, pickerView == latPicker ? @"S" : @"E"];
            }
        case 1 :
            return [NSString stringWithFormat:@"%d'",row];
        case 2:
            return [NSString stringWithFormat:@"%d\"",row];
        default :
            return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == latPicker) {
        switch (component) {
            case 0:
                latDeg = 89 - row;
                break;
            case 1:
                latMin = row;
                break;
            case 2:
                latSec = row;
                break;
            default:
                break;
        }
    } else {
        switch (component) {
            case 0:
                lonDeg = 179 - row;
                break;
            case 1:
                lonMin = row;
                break;
            case 2:
                lonSec = row;
                break;
            default:
                break;
        }
    }
    [self updateLatLonFields];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) updateLatLonFields
{
    [latitudeField setText:[NSString stringWithFormat: @"%i° %i' %i\" %@",
                            abs(self->latDeg),
                            latMin,
                            latSec,
                            latDeg < 0 ? @"S" : @"N"]];
    [longitudeField setText:[NSString stringWithFormat: @"%i° %i' %i\" %@",
                             abs(self->lonDeg),
                             lonMin,
                             lonSec,
                             lonDeg < 0 ? @"W" : @"E"]];
}

@end
