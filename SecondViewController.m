//
//  SecondViewController.m
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "CocoaXMLParser.h"
#import "DetailController.h"

@implementation SecondViewController

@synthesize myParser, shows;



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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (shows == nil) {
        self.shows = [NSMutableArray array];
    } else {
        [shows removeAllObjects];
        [self.tableView reloadData];
    }
    
    self.myParser = [[[CocoaXMLParser alloc] init] autorelease];
    
    myParser.delegate = self;
    [myParser start];
    

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

- (void)parserDidEndParsingData:(ShowRSSParser *)parser {
    self.title = [NSString stringWithFormat:NSLocalizedString(@"All %d Shows", @"Top Songs format"), [shows count]];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.myParser = nil;
}

- (void)parser:(ShowRSSParser *)parser didParseShows:(NSArray *)parsedShows{
    [shows addObjectsFromArray:parsedShows];
    // Three scroll view properties are checked to keep the user interface smooth during parse. When new objects are delivered by the parser, the table view is reloaded to display them. If the table is reloaded while the user is scrolling, this can result in eratic behavior. dragging, tracking, and decelerating can be checked for this purpose. When the parser finishes, reloadData will be called in parserDidEndParsingData:, guaranteeing that all data will ultimately be displayed even if reloadData is not called in this method because of user interaction.
    if (!self.tableView.dragging && !self.tableView.tracking && !self.tableView.decelerating) {
        self.title = [NSString stringWithFormat:NSLocalizedString(@"All %d Shows", @"Top Songs format"), [shows count]];
        [self.tableView reloadData];
    }
}




@end
