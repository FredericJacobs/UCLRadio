#import "AppDelegate.h"
#import "UCLRadioViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController, secondViewController, subscribedShows;

- (BOOL) alreadySubscribedToShow: (Show *)aShow {
    BOOL subScriptionsAreTheSame = FALSE;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *subscribedShowsFileName = [documentsDirectory stringByAppendingPathComponent:@"Subscriptions.dat"];
    
    //Load the array
    subscribedShows = [[NSMutableArray alloc] initWithContentsOfFile: subscribedShowsFileName];
    if(subscribedShows == nil)
    {
        //Array file didn't exist... create a new one
        subscribedShows = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSLog(@"This Array is empty");
        
    }
    
    if (subscribedShows != nil){
        
        NSLog(@"%d", [subscribedShows count]);
        
        for (int i =0;[subscribedShows count]<i; i++){
            
            if (aShow.name == [[subscribedShows objectAtIndex:i] name]){
                subScriptionsAreTheSame = TRUE;
            }
            NSLog(@"One Entry");
            
        }
        
    }
    
    return subScriptionsAreTheSame;
    
}


- (void) addShow: (Show *)newShow {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *subscribedShowsFileName = [documentsDirectory stringByAppendingPathComponent:@"Subscriptions.dat"];
    
    //Load the array
    subscribedShows = [[NSMutableArray alloc] initWithContentsOfFile: subscribedShowsFileName];
    if(subscribedShows == nil)
    {
        //Array file didn't exist... create a new one
        subscribedShows = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    
    if (subscribedShows != nil){
        if ([self alreadySubscribedToShow:newShow]){
            NSLog(@"Entry Already Exists");   
        }
        
        if (![self alreadySubscribedToShow:newShow]){
            
            [subscribedShows addObject:newShow];
            
        }
    }
    
    [subscribedShows writeToFile:subscribedShowsFileName atomically:YES];
    
    
}




- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

