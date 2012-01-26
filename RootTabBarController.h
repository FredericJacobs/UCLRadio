//
//  RootTabBarController.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 1/26/12.
//  Copyright (c) 2012 EPFL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchTest.h"
@class Reachability;


@interface RootTabBarController : UITabBarController{
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
    LaunchTest *launchTest;

}
@property (nonatomic) BOOL internetActive;
@property (nonatomic) BOOL hostActive;

- (void) checkNetworkStatus:(NSNotification *)notice;

@end
