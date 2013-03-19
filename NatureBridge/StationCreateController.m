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

@interface StationCreateController ()

@end

@implementation StationCreateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Create a new location"];
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
    // Default pickers to Olympic National Park
    [latitude selectRow:42 inComponent:0 animated:NO];
    [latitude selectRow:58 inComponent:1 animated:NO];
    [latitude selectRow:10 inComponent:2 animated:NO];
    [longitude selectRow:56 inComponent:0 animated:NO];
    [longitude selectRow:29 inComponent:1 animated:NO];
    [longitude selectRow:55 inComponent:2 animated:NO];
    [latitude reloadAllComponents];
    [longitude reloadAllComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onSave
{
    double lat = 89 - [latitude selectedRowInComponent:0];
    lat += [latitude selectedRowInComponent:1] / 60.0;
    lat += [latitude selectedRowInComponent:2] / 3600.0;
    double lon = 179 - [longitude selectedRowInComponent:0];
    lon += [longitude selectedRowInComponent:1] / 60.0;
    lon += [longitude selectedRowInComponent:2] / 3600.0;
    
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:[FSStations tableName]
                                            inManagedObjectContext:[[FSStore dbStore] context]];
    [station setName:[nameField text]];
    [station setLatitude:lat andLongitude:lon];
    [station setProject:[FSProjects currentProject]];
    
    if([[station name] length] == 0) {
        [station setName:[NSString stringWithFormat:@"ø %@", [station prettyLocation]]];
    }
    
    [[FSStore dbStore] saveChanges];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return pickerView == latitude ? 180 : 360;
    } else {
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger middle = pickerView == latitude ? 90 : 180;

    switch(component) {
        case 0 :
            if (row < middle) {
                return [NSString stringWithFormat:@"%d°%@",middle - row - 1,pickerView == longitude ? @"W" : @"N"];
            } else {
                return [NSString stringWithFormat:@"%d°%@",row - middle, pickerView == longitude ? @"E" : @"S"];
            }
        case 1 :
            return [NSString stringWithFormat:@"%d'",row];
        case 2:
            return [NSString stringWithFormat:@"%d\"",row];
        default :
            return @"";
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
