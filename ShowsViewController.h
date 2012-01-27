//
//  SecondViewController.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "EGORefreshTableHeaderView.h"

@class DetailController;

@interface ShowsViewController : UITableViewController <EGORefreshTableHeaderDelegate>{
    IBOutlet UITableView *allShows;
    NSMutableArray *shows;
    DetailController *detailController;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic, retain, readonly) DetailController *detailController;
@property (nonatomic, retain) NSMutableArray *shows;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

