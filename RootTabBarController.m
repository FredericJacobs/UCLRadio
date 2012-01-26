//
//  RootTabBarController.m
//  UCLRadio
//
//  Created by Frederic Jacobs on 1/26/12.
//  Copyright (c) 2012 EPFL. All rights reserved.
//

#import "RootTabBarController.h"
#import "LaunchTest.h"
#import "Reachability.h"
#import "AppDelegate.h"

@implementation RootTabBarController
@synthesize internetActive, hostActive;

-(void) viewDidAppear:(BOOL)animated{

    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
    [hostReachable startNotifier];
    // now patiently wait for the notification
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void) checkNetworkStatus:(NSNotification *)notice{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            launchTest = [[LaunchTest alloc] initWithNibName:@"LaunchTest" bundle:nil];
            [self presentViewController:launchTest animated:NO completion:nil];
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            launchTest.statusLabel.text = @"This app needs a working internet connection to work. Relaunch the app when online.";
            break;
        }
        case ReachableViaWiFi:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            break ;
        }
        case ReachableViaWWAN:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            break ;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
            
        }
    }
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

@end
