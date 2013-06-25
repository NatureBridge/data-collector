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
#import "NBRange.h"
#import "NBSettings.h"
#import "NotesCell.h"

@interface ObservationViewController ()

@end

@implementation ObservationViewController

@synthesize popupVC;

-(void) displayPopup:(FieldCell *)cell rect:(CGRect)rect
                arrow:(UIPopoverArrowDirection)direction
{   //NSLog(@"ObservationVC: displayPopup.");
    popUpController=[[UIPopoverController alloc]
        initWithContentViewController:popupVC];
    [popUpController presentPopoverFromRect:rect inView:cell
        permittedArrowDirections:direction animated:YES];
    popUpController.delegate=self;
    // Call PopupViewController to set size
    [popupVC load:cell];
}
-(void) dismissPopup
{   //NSLog(@"ObservationVC: dismissPopup.");
    [popUpController dismissPopoverAnimated:YES];
    popUpController = nil;
    //NSLog(@"ObservationVC: dismissPopup done.");
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)sender
{   NSLog(@"ObservationVC: popoverControllerDidDismissPopover.");
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
        backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onBack)];
        [[self navigationItem] setLeftBarButtonItem:backButton];
        editButton = [[UIBarButtonItem alloc] initWithTitle:@"View  >"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onEdit)];
        [[self navigationItem] setRightBarButtonItem:editButton];

    } else {
        [NBSettings setEditFlag:YES];
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(onCancel)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onSave)];
        [[self navigationItem] setRightBarButtonItem:saveButton];
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
{   //NSLog(@"ObservationVC onSave");
    [[FSStore dbStore] saveChanges];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (void) onCancel
{   //NSLog(@"ObservationVC onCancel");
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
        clickedButtonAtIndex:(NSInteger)buttonIndex
{   //NSLog(@"ObservationVC Cancel popup click");
	NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"Yes"]) {
        // Do NOT do a [[FSStore dbStore] saveChanges]
        if([[observation committedValuesForKeys:nil] count] == 0) {
            [FSObservations deleteObservation:observation];
        }
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void) onBack
{   //NSLog(@"ObservationVC onBack");
    if ([NBSettings editFlag]) {
        //NSLog(@"ObservationVC saveChanges");
        [[FSStore dbStore] saveChanges];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void) onEdit
{   //NSLog(@"ObservationVC onEdit");
    if ([NBSettings editFlag]) {
        [NBSettings setEditFlag:NO];
        [backButton setTitle:@"Back"];
        [editButton setTitle:@"View >"];
    } else {
        [NBSettings setEditFlag:YES];
        [backButton setTitle:@"Save"];
        [editButton setTitle:@"Edit >"];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{   //NSLog(@"ObservationVC viewWillDisappear");
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if (observation) {
            if([[observation committedValuesForKeys:nil] count] == 0) {
                //NSLog(@"ObservationVC deleteObservation");
                [FSObservations deleteObservation:observation];
            }
        }
    }
    //[super viewWillDisappear:animated];
}
@end
