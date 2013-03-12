//
//  ProjectsIndexViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectsIndexViewController : UITableViewController <UIAlertViewDelegate>
{
    IBOutlet UIView *headerView;
    UITextField *userInput;
}
- (UIView *) headerView;
- (void) getSiteId;

@end
