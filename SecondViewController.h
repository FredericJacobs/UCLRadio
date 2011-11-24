//
//  SecondViewController.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowRSSParser.h"

@class DetailController;

@interface SecondViewController : UITableViewController<ShowRSSParserDelegate>{
    IBOutlet UITableView *allShows;
    ShowRSSParser *myParser;
    NSMutableArray *shows;
    DetailController *detailController;
    
}

@property (nonatomic, retain) NSMutableArray *shows;
@property (nonatomic, retain) ShowRSSParser *myParser;
@property (nonatomic, retain, readonly) DetailController *detailController;

- (id) init;


@end

