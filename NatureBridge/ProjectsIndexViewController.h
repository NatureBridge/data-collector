//
//  ProjectsIndexViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldScope/FSProjects.h"

@interface ProjectsIndexViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}
- (UIView *) headerView;

@end
