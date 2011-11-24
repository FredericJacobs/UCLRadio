//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "DetailController.h"
#import "Show.h"


@implementation DetailController

@synthesize show, dateFormatter, showToSubscribe, appDelegate;


- (void)dealloc {
    [dateFormatter release];
    [show release];
    [super dealloc];
}

- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;
}

// When the view appears, update the title and table contents.
- (void)viewWillAppear:(BOOL)animated {
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = show.name;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 4;
}



- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [appDelegate addShow:show];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ShowDetailCell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = NSLocalizedString(@"Starts at ", @"album label");
            cell.detailTextLabel.text = show.startTime;
        } break;
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"artist", @"artist label");
            cell.detailTextLabel.text = show.endTime;
        } break;
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"category", @"category label");
            cell.detailTextLabel.text = show.dayOfTheWeek;
        } break;
        case 3: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
            cell.textLabel.text = @"Subscribe";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
    }
    return cell;
}



- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Show details:", @"Show details label");
}


@end
