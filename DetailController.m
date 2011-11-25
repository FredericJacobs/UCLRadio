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

- (void) viewDidLoad{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate initializeArray];
    
}

// When the view appears, update the title and table contents.
- (void)viewWillAppear:(BOOL)animated {
    self.title = show.name;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 4;
}



- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 3){
        
    if ([appDelegate isSubscribedTo:show]){
    
        [appDelegate removeShow:show];
        
        [[[table cellForRowAtIndexPath:indexPath] textLabel]setText:@"Subscribe"];
        
    }
    
    else {
        
        [appDelegate addShow:show];
        [[[table cellForRowAtIndexPath:indexPath] textLabel] setText:@"You are already subscribed"];
        
        
    }
    }
    
    [[table cellForRowAtIndexPath:indexPath] setSelected:FALSE];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ShowDetailCell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"Starts at ", @"album label");
            cell.detailTextLabel.text = [[show startTime] stringByAppendingFormat:@":00"]; ;
        } break;
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"Ends at", @"artist label");
            cell.detailTextLabel.text = [[show endTime] stringByAppendingFormat:@":00"];
        } break;
        case 0: {
            cell.textLabel.text = NSLocalizedString(@"Weekday", @"category label");
            int i = [[show dayOfTheWeek]intValue];
            switch (i) {
                case 1:{cell.detailTextLabel.text = @"Sunday";}
                    break;
                    
                case 2:{cell.detailTextLabel.text = @"Monday";}
                    break;
                    
                case 3:{cell.detailTextLabel.text = @"Tuesday";}
                    break;
                case 4:{cell.detailTextLabel.text = @"Wednesday";}
                    break;
                case 5:{cell.detailTextLabel.text = @"Thursday";}
                    break;
                case 6:{cell.detailTextLabel.text = @"Friday";}
                    break;
                case 7:{cell.detailTextLabel.text = @"Saterday";}
                    break;
                default:
                    break;
            }
        } break;
        case 3: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            
            
            if ([appDelegate isSubscribedTo:show]){
                cell.textLabel.text = @"You are already subscribed";
                
            }
            
            else {
            
           cell.textLabel.text = @"Subscribe";
        
            }
}
    }   return cell;
}



- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Show details:", @"Show details label");
}


@end
