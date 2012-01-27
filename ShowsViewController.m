//
//  SecondViewController.m
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowsViewController.h"
#import "DetailController.h"
#import <QuartzCore/QuartzCore.h>




@implementation ShowsViewController

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

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startParser];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadTableViewDataSourcePARTTwo:) userInfo:nil repeats:NO];
}

- (void) reloadTableViewDataSourcePARTTwo:(id)sender {
    _reloading = YES;
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    shows = [[NSMutableArray alloc] initWithArray:[appDelegate getShows]];
    [self.tableView reloadData];
    NSLog(@"Data reloaded");
    [self doneLoadingTableViewData];
    
}


- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    shows = [[NSMutableArray alloc] initWithArray:[appDelegate getShows]];

    [super viewDidLoad];
    if (shows == nil) {
        self.shows = [NSMutableArray array];
        NSLog(@"Shows is void");
    } 
    else {
        [self.tableView reloadData];
        NSLog(@"Data reloaded");
    }

    // Do any additional setup after loading the view from its nib
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
    [super viewDidLoad];
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
	

}


- (void)viewDidUnload
{
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
