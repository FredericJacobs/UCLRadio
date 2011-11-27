//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class Show;

@interface DetailController : UITableViewController {
    NSDateFormatter *dateFormatter;
    Show *show;
    Show *showToSubscribe;
    AppDelegate *appDelegate;
}

@property (nonatomic, retain) Show *show;
@property (nonatomic, readonly, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, readwrite, retain) Show *showToSubscribe;
@property (nonatomic, retain) AppDelegate *appDelegate;




@end
