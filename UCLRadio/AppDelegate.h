//
//  AppDelegate.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
#import "ShowsParser.h"


@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIBackgroundTaskIdentifier bgTask;
    NSMutableArray *subscribedShows;
    ShowsParser *myParser;
    NSString *currentShow;
    NSTimeInterval timeUntilNextShow;

}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSMutableArray *subscribedShows;
@property (nonatomic, retain) ShowsParser *myParser;
@property (nonatomic, retain) NSString *currentShow;


- (NSArray *) getSubscriptions ;
- (void) startParser;
- (void) addShow: (Show *)newShow ;
- (void) removeShow: (Show*)newShow ;
- (void) initializeArray;
- (BOOL) isSubscribedTo: (Show*)newShow;
- (void) printToConsole;
- (void) updateNotifications;
- (NSDate *) returnAFutureDate: (NSDate*) aDate;
- (NSMutableArray*) getShows ;
- (NSString *) getShowName;


@end
