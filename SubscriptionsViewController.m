//
//  SecondViewController.m
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionsViewController.h"
#import "DetailController.h"
#import <QuartzCore/QuartzCore.h>


@implementation SubscriptionsViewController

@synthesize shows;


- (id) init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)allShows{
    
    return 1;
    
}

- (DetailController *)detailController {
    if (detailController == nil) {
        detailController = [[DetailController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return detailController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate initializeArray];
    shows = [NSMutableArray arrayWithArray:[appDelegate getSubscriptions]];
    [self.tableView reloadData];
    [super viewDidLoad];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shows count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"MyCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [shows sortUsingSelector:@selector(compareWithAnotherShow:)];
    
    cell.textLabel.text = [[shows objectAtIndex:indexPath.row] name];    
    return cell;
    
    
}


- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailController.show = [shows objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.detailController animated:YES];
}

- (void) viewDidLoad {
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate initializeArray];
    shows = [[NSMutableArray alloc] initWithArray:[appDelegate getSubscriptions]];
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [shows dealloc];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}



@end
