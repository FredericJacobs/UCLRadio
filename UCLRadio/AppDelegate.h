//
//  AppDelegate.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"

@class UCLRadioViewController;
@class SecondViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IBOutlet UCLRadioViewController *viewController;
    UIBackgroundTaskIdentifier bgTask;
    IBOutlet SecondViewController *secondViewController;
    NSMutableArray *subscribedShows;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UCLRadioViewController *viewController;
@property (nonatomic, retain) IBOutlet SecondViewController *secondViewController;
@property (nonatomic, retain) NSMutableArray *subscribedShows;

- (void) addShow: (Show *)newShow ;
- (void) removeShow: (Show*)newShow ;
- (void) initializeArray;
- (BOOL) isSubscribedTo: (Show*)newShow;
- (void) printToConsole;
- (void) updateNotifications;
- (NSDate *) returnAFutureDate: (NSDate*) aDate;

@end
