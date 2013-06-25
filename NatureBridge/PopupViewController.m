//
//  PopupViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "PopupViewController.h"

@implementation PopupViewController

- (void)viewDidLoad {
    //NSLog(@"PopupVC: viewDidLoad");
    [super viewDidLoad];
}
// Call Cell specific method to Display Input Form
- (void)load:(FieldCell *)cell
{   //NSLog(@"PopupVC: load: %@",cell.class);
    CGSize size = [cell displayInputForm:self.view];
    //NSLog(@"PopupVC: load size: %f,%f",size.width,size.height);
    self.contentSizeForViewInPopover=size;
    [super viewDidLoad];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (void)didReceiveMemoryWarning
{   [super didReceiveMemoryWarning];
}
@end
