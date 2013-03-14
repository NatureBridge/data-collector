//
//  ObservationViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "ObservationViewController.h"
#import "Observation.h"
#import "Station.h"
#import "Field.h"
#import "FieldGroup.h"
#import "FSStore.h"
#import "FSObservations.h"
#import "FSProjects.h"
#import "FieldCell.h"
#import "NumberCell.h"
#import "RangeCell.h"
#import "ListCell.h"
#import "StringCell.h"
#import "NumericPadViewController.h"
#import "ListViewController.h"
#import "NBRange.h"
#import "NBSettings.h"
#import "NotesCell.h"

@interface ObservationViewController ()

@end

@implementation ObservationViewController

@synthesize numPad;
@synthesize listPad;

- (void)loadNumPad:(UIButton *)button cell:(FieldCell *)cell
{
    curButton = button;
    curCell = cell;
    NSString *value = button.titleLabel.text;
    if (value == nil) value = @"";
    if (numPad.value == nil) {
        numPad.value = [[NSMutableString alloc]initWithCapacity:10];
    }
    [numPad.value setString:value];
    numPad.units = [[curCell field] units];
    numPad.min = [[curCell field] minimum];
    numPad.max = [[curCell field] maximum];
    numPad.valueFld.text = value;
    numPad.unitsFld.text = [[curCell field] units];
    if (popUpController == nil) {
        popUpController=[[UIPopoverController alloc]
                         initWithContentViewController:numPad];
        [popUpController presentPopoverFromRect:[button frame]
                                         inView:cell
                       permittedArrowDirections:UIPopoverArrowDirectionLeft
                                       animated:YES];
        popUpController.delegate=self;
    }
}

-(void) loadListPad:(UIButton *)button cell:(FieldCell *)cell list:(NSArray *)options
{
    curButton = button;
    curCell = cell;
    if (popUpController == nil) {
        popUpController=[[UIPopoverController alloc]
                         initWithContentViewController:listPad];
        [popUpController presentPopoverFromRect:[button frame]
                                         inView:cell
                       permittedArrowDirections:UIPopoverArrowDirectionLeft
                                       animated:YES];
        popUpController.delegate=self;
    }
    [listPad load:options];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)sender
{
    if (popUpController.contentViewController == numPad) {
        NSString *value = [[NSString alloc] initWithString:numPad.value];
        if ([value length] > 0) {
            // Range Check Value - In Case PopUp not closed by Save button
            NSNumber *number = [[NSNumber alloc] initWithFloat:[value floatValue]];
            if (![NBRange check:number
                            min:[[curCell field] minimum]
                            max:[[curCell field] maximum]] ) {
                value = nil;
            }
        }
        // Save Field Value
        if (value != nil) {
            [curButton setTitle:value forState:UIControlStateNormal];
            [[curCell data] setStringValue:value];
        }
    }
    if (popUpController.contentViewController == listPad) {
        NSString *value = [[NSString alloc] initWithString:listPad.value];
        NSString *text = [[NSString alloc] initWithString:listPad.text];
        [curButton setTitle:text forState:UIControlStateNormal];
        [[curCell data] setStringValue:value];
    }
    popUpController = nil;
    curButton = nil;
    curCell = nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithObservation:(Observation *)newObservation
{
    self = [super init];
    if (self) {
        observation = newObservation;
        [[self navigationItem] setTitle:[[observation station] name]];
        NSSortDescriptor *sortByOrdinal = [[NSSortDescriptor alloc] initWithKey:@"ordinal" ascending:YES];
        fieldGroups = [[[FSProjects currentProject] fieldGroups] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByOrdinal]];
        fieldsFromFieldGroups = [[NSMutableDictionary alloc] init];
        for (FieldGroup *fieldGroup in fieldGroups) {
            NSArray *fields = [[fieldGroup fields] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByOrdinal]];
            [fieldsFromFieldGroups setObject:fields forKey:[fieldGroup name]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([NBSettings viewFlag]) {
        [NBSettings setEditFlag:NO];
        editButton = [[UIBarButtonItem alloc] initWithTitle:@"View  >"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onEditButton)];
        [[self navigationItem] setRightBarButtonItem:editButton];
    } else {
        [NBSettings setEditFlag:YES];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(onSave)];
        [[self navigationItem] setRightBarButtonItem:saveButton];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(onCancel)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [fieldGroups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    FieldGroup *fieldGroup = [fieldGroups objectAtIndex:section];
    return [fieldGroup name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    FieldGroup *fieldGroup = [fieldGroups objectAtIndex:section];
    return [[fieldsFromFieldGroups objectForKey:[fieldGroup name]] count];
}

- (Class)classForField:(Field *) field
{
    if([[field values] count] > 0) {
        return [ListCell class];
    } else if(field.minimum && field.maximum && ![[field minimum] isEqualToNumber:[field maximum]]) {
        if ([NBSettings isSlider:field.name]) {
            return [RangeCell class];
        } else {
            return [NumberCell class];
        }
    } else if([[field type] isEqualToString:@"Number"]) {
        return [NumberCell class];
    } else if([[field label] isEqualToString:@"Notes"]) {
        return [NotesCell class];
    } else {
        return [StringCell class];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FieldGroup *fieldGroup = [fieldGroups objectAtIndex:[indexPath section]];
    Field *field = [[fieldsFromFieldGroups objectForKey:[fieldGroup name]] objectAtIndex:[indexPath row]];
    Class fieldCellClass = [self classForField:field];
    
    FieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[fieldCellClass identifier]];
    if (cell == nil) {
        cell = [[fieldCellClass alloc] initWithField:field forObservation:observation];
    } else {
        [cell setField:field];
        [cell setObservation:observation];
    }
    [cell updateValues];
    
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FieldGroup *fieldGroup = [fieldGroups objectAtIndex:[indexPath section]];
    Field *field = [[fieldsFromFieldGroups objectForKey:[fieldGroup name]] objectAtIndex:[indexPath row]];
    Class fieldCellClass = [self classForField:field];
    return [fieldCellClass cellHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) onSave
{
    [[FSStore dbStore] saveChanges];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}
- (void) onCancel
{   //NSLog(@"ObservationViewController: onCancel");
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"CANCEL OBSERVATION"
                   message:@"Are you sure ?"
                   delegate: self
                   cancelButtonTitle: @"No"
                   otherButtonTitles: @"Yes", nil];
	[alertDialog show];
}
- (void)alertView:(UIAlertView *)alertView
        clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"Yes"]) {
		//NSLog(@"ObservationViewController:Cancel: Yes");
        // Do NOT do a [[FSStore dbStore] saveChanges]
        if([[observation committedValuesForKeys:nil] count] == 0) {
            //NSLog(@"ObservationViewController: deleteObservation");
            [FSObservations deleteObservation:observation];
        }
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
	} else {
        //NSLog(@"ObservationViewController:Cancel: No");  // Do nothing
    }
}
- (void) onEditButton
{
    if ([NBSettings editFlag]) {
        [NBSettings setEditFlag:NO];
        [editButton setTitle:@"View >"];
    } else {
        [NBSettings setEditFlag:YES];
        [editButton setTitle:@"Edit >"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{   //NSLog(@"ObservationViewController: viewWillDisappear");
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if (observation)
            if([[observation committedValuesForKeys:nil] count] == 0) {
                //NSLog(@"ObservationViewController: deleteObservation");
                [FSObservations deleteObservation:observation];
            }
    }
    [super viewWillDisappear:animated];
}
@end
