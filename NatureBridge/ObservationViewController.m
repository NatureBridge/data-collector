//
//  ObservationViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
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
#import "NBRange.h"
#import "NBSettings.h"
#import "NotesCell.h"

@interface ObservationViewController ()

@end

@implementation ObservationViewController

@synthesize numPad;

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
    if (numPadController == nil) {
        numPadController=[[UIPopoverController alloc]
                          initWithContentViewController:numPad];
        [numPadController presentPopoverFromRect:[button frame] inView:cell
                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        numPadController.delegate=self;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)sender
{
    NSString *value = [[NSString alloc] initWithString:numPad.value];
    if ([value length] > 0) {
        // Range Check Value - In Case PopUp not closed by Save button
        NSNumber *number = [[NSNumber alloc] initWithFloat:[value floatValue]];
        if ( ! [NBRange check:number
                          min:[[curCell field] minimum]
                          max:[[curCell field] maximum]]) {
            value = nil;
        }
    }
    // Save Field Value
    if (value != nil) {
        [curButton setTitle:value forState:UIControlStateNormal];
        [[curCell data] setStringValue:value];
    }
    numPadController = nil;
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
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        fieldGroups = [[[FSProjects currentProject] fieldGroups] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
        fieldsFromFieldGroups = [[NSMutableDictionary alloc] init];
        for (FieldGroup *fieldGroup in fieldGroups) {
            NSSortDescriptor *sortByLabel = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:YES];
            NSArray *fields = [[fieldGroup fields] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByLabel]];
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
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onSave)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
 }
 */

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

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([[observation committedValuesForKeys:nil] count] == 0) {
            [FSObservations deleteObservation:observation];
        }
    }
    [super viewWillDisappear:animated];
}

@end
