#import "AppDelegate.h"
#import "UCLRadioViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController, secondViewController, subscribedShows;

- (void) initializeArray {
    subscribedShows = [[NSMutableArray alloc] initWithCapacity:1000];
    [self updateNotifications];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    

    
    
}

- (void) removeShow:(Show *)newShow{
    
    
    for (int i=0; i < [subscribedShows count]; i++){
            
    if ( [newShow name] == [[subscribedShows objectAtIndex:i]name]){
        [subscribedShows removeObjectAtIndex:i];
            }
            
            else {
                
                NSLog(@"Remove Bug");
                
            }
        }
    
    [self updateNotifications] ;
}

- (NSDate *) parseShowIntoNSDateWeekOne: (Show *)aShow {
    NSDate *myDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:myDate];
    NSTimeZone *london = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [weekdayComponents setTimeZone:london];
    [weekdayComponents setWeekday:[[aShow dayOfTheWeek] intValue]];
    [weekdayComponents setHour:[[aShow startTime] intValue]-1];
    [weekdayComponents setMinute:55];
    
    NSDate *notificationDate = [weekdayComponents date];

    while ([notificationDate timeIntervalSinceDate:myDate]>0){
        [weekdayComponents setWeek:([weekdayComponents week]+1)];
        notificationDate =[weekdayComponents date];
        
    }

    return notificationDate;
    
}



- (void) makeLocalNotificationOne: (Show *)aShow{
    NSDate *itemDate = [self parseShowIntoNSDateWeekOne:aShow];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in 5 minutes.", [aShow name])];
    localNotif.alertAction = NSLocalizedString(@"Tune In !", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[aShow name] forKey:[aShow name]];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    NSLog(@"Registred for Push !");
}

- (void) printToConsole {
    for (int i=0; i < [subscribedShows count]; i++){
        NSLog(@"%@",[[subscribedShows objectAtIndex:i]name]);
        
    }
    
}

- (BOOL) isSubscribedTo: (Show*)newShow{
    
    BOOL isSubscribed;
    
    if ([subscribedShows count] == 0){
        isSubscribed = FALSE;   
    }
    
    else {
        
        for (int i=0; i < [subscribedShows count]; i++){
            
            if ( [newShow name] == [[subscribedShows objectAtIndex:i]name]){
                isSubscribed = TRUE;
            }
            
            else {
                isSubscribed = FALSE;
            }
        }
    }
    return isSubscribed;
}

- (void) addShow: (Show *)newShow {
    
    
    if ([subscribedShows count] == 0){
        
        [subscribedShows addObject:newShow];
        
    }
    
    else {
        for (int i=0; i < [subscribedShows count]; i++){

            if ( [newShow name] == [[subscribedShows objectAtIndex:i]name])
            {
        
                NSLog(@"This is a duplicate");
                NSLog(@"Still %d entries", [subscribedShows count]);
            }
        
            else
            {
        
            NSLog(@"Else happens");
         
            [subscribedShows addObject:newShow];
    
            }
        }
    }
    [self printToConsole];
    [self updateNotifications];
}
    

- (void) updateNotifications{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSLog(@"%d",[subscribedShows count]);
    
    for (int i=0; i < [subscribedShows count]; i++){
        [self makeLocalNotificationOne:[subscribedShows objectAtIndex:i]];
    }
    
    
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}



@end

