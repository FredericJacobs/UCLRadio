#import "AppDelegate.h"
#import "UCLRadioViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController, secondViewController, subscribedShows;

- (void) initializeArray {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *filePath =  [libraryDirectory stringByAppendingPathComponent:@"Subscriptions.txt"];
    subscribedShows = [[NSMutableArray alloc] initWithCapacity:1000];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
    
        NSMutableArray *restoreArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        for ( int i = 0; i < [restoreArray count]; i++) {
            [subscribedShows addObject:[Show fromString:[restoreArray objectAtIndex:i]]];
        }
        
    }
    
    
    [self updateNotifications];
}

- (void) saveToDisk {
    
    NSMutableArray *toBeSaved = [[NSMutableArray alloc ] initWithCapacity:1000]; 
    for (int i = 0 ; i < [subscribedShows count] ; i++){
        [toBeSaved addObject:[Show toString:[subscribedShows objectAtIndex:i]]];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *filePath =  [libraryDirectory stringByAppendingPathComponent:@"Subscriptions.txt"];
    
    [toBeSaved writeToFile:filePath atomically:YES];
    [toBeSaved release];
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    UIAlertView *alert = [UIAlertView alloc];
    [alert initWithTitle:@"Don't miss your show !" message:notification.alertBody delegate: self cancelButtonTitle:@"Tune In" otherButtonTitles:nil , nil];
    [alert show];
    [self updateNotifications];    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void) applicationSignificantTimeChange:(UIApplication *)application{
    
    [self updateNotifications];
    
}


-(void) applicationWillEnterForeground:(UIApplication *)application{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self updateNotifications];
    
}

-(void) applicationDidFinishLaunching:(UIApplication *)application{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void) removeShow:(Show *)newShow{
    
    if ([self isSubscribedTo:newShow]) {
        
        for (int i=0; i < [subscribedShows count]; i++){
        
            if ( [[newShow name] isEqualToString:[[subscribedShows objectAtIndex:i]name]]){
                [subscribedShows removeObjectAtIndex:i];
            }
            
        }
    }
    
    [self updateNotifications] ;
}

- (NSDate *) parseShowIntoNSDate: (Show *)aShow {

    NSDate *today = [NSDate date];
    
    NSDate *show = [NSDate alloc];
    
    NSDateComponents *showComponents = [[NSDateComponents alloc] init];
    
    if ([[aShow startTime] integerValue] == 0 )
    {
        if ([[aShow dayOfTheWeek] integerValue] == 1){
            
            [showComponents setWeekday:7];
            [showComponents setHour:23];
            
        }
        
        else {
            
            [showComponents setWeekday:([[aShow dayOfTheWeek] integerValue]-1)];
            [showComponents setHour:23];
        }
        
    }
    
    else {
        
        [showComponents setWeekday:[[aShow dayOfTheWeek] integerValue]];
        [showComponents setHour:([[aShow startTime] integerValue]- 1)];
        
    }
    
    [showComponents setMinute:55];
    [showComponents setYear:[[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:today] year]];
    [showComponents setWeek:[[[NSCalendar currentCalendar] components:NSWeekCalendarUnit fromDate:today] week]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [showComponents setWeek:[[[NSCalendar currentCalendar] components: NSWeekCalendarUnit fromDate:today] week]];
    
    show = [gregorian dateFromComponents:showComponents];
    
    // Support for TimeZone 
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:show];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:show];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset ; 
    return [self returnAFutureDate:[[NSDate alloc]initWithTimeInterval:interval sinceDate:show]];
    
}

- (NSDate *) returnAFutureDate: (NSDate*) aDate {
    // Check if date already happened if yes return a date one week later 
    while ([aDate timeIntervalSinceNow] < 0){
        //Rescheldule next week 
        aDate = [aDate dateByAddingTimeInterval:604800];
    }
    return aDate;
}



- (void) makeLocalNotificationOne: (Show *)aShow{
    
    NSDate *itemDate = [self parseShowIntoNSDate:aShow];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    
    localNotif.alertBody = [[aShow name]stringByAppendingString:(@" starts in 5 min")];
    localNotif.alertAction = NSLocalizedString(@"Tune In !", nil);
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[aShow name] forKey:[aShow name]];
    localNotif.userInfo = infoDict;
    
    NSLog(@"Local Notification time is %@",[itemDate description]);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}

- (void) printToConsole {
    for (int i=0; i < [subscribedShows count]; i++){
        NSLog(@"%@",[[subscribedShows objectAtIndex:i]name]);
        
    }
    
}

- (BOOL) isSubscribedTo: (Show*)newShow{
    
    BOOL isSubscribed = FALSE;
    
    if ([subscribedShows count] == 0){
        isSubscribed = FALSE;   
    }
    
    else {
        for (int i=0; i < [subscribedShows count]; i++){
            if ([[newShow name] isEqualToString:[[subscribedShows objectAtIndex:i]name]]){
                isSubscribed = TRUE;
            }
            
            else {
                
            }
        }
    }
    NSLog(@"Returned %d", isSubscribed);
    return isSubscribed;

}

- (void) addShow: (Show *)newShow {
    
    
    if ([subscribedShows count] == 0){
        
        [subscribedShows addObject:newShow];
        
    }
    
    else {
        for (int i=0; i < [subscribedShows count]; i++){

            if ([self isSubscribedTo:newShow])
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
    [self updateNotifications];
}
    

- (void) updateNotifications{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSLog(@"%d",[subscribedShows count]);
    
    for (int i=0; i < [subscribedShows count]; i++){
        [self makeLocalNotificationOne:[subscribedShows objectAtIndex:i]];
    }
    
    [self saveToDisk];
    
    
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}



@end

