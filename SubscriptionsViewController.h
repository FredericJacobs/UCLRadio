//
//  SecondViewController.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"


@class DetailController;

@interface SubscriptionsViewController : UITableViewController {
    IBOutlet UITableView *allShows;
    NSMutableArray *shows;
    DetailController *detailController;
}

@property (nonatomic, retain, readonly) DetailController *detailController;
@property (nonatomic, retain) NSMutableArray *shows;

@end

