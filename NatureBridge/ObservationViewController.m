//
//  ObservationViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "ObservationViewController.h"
#import "Field.h"
#import "FieldGroup.h"
#import "FSStore.h"
#import "FSObservations.h"
#import "FSProjects.h"
#import "FieldCell.h"
#import "NumberCell.h"
#import "RangeCell.h"
#import "PickerCell.h"
#import "StringCell.h"

@interface ObservationViewController ()

@end

@implementation ObservationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Observation"];
    }
    return self;
}

- (id)initWithStation:(Station *)station
{
    self = [super init];
    if (self) {
        observation = [FSObservations createObservation:station];
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        fieldGroups = [[[FSProjects currentProject] fieldGroups] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
        fieldsFromFieldGroups = [[NSMutableDictionary alloc] init];
        for (FieldGroup *fieldGroup in fieldGroups) {
            NSArray *fields = [[fieldGroup fields] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
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
        return [PickerCell class];
    } else if(field.minimum && field.maximum && ![[field minimum] isEqualToNumber:[field maximum]]) {
        NSLog(@"min: %@, max: %@", field.minimum, field.maximum);
        return [RangeCell class];
    } else if([[field type] isEqualToString:@"Number"]) {
        return [NumberCell class];
    } else {
        return [StringCell class];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FieldGroup *fieldGroup = [fieldGroups objectAtIndex:[indexPath section]];
    Field *field = [[[fieldsFromFieldGroups objectForKey:[fieldGroup name]] allObjects] objectAtIndex:[indexPath row]];
    Class fieldCellClass = [self classForField:field];

    FieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[fieldCellClass identifier]];
    if (cell == nil) {
        cell = [[fieldCellClass alloc] initWithField:field];
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
        [FSObservations deleteObservation:observation];
    }
    [super viewWillDisappear:animated];
}

@end
