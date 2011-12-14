//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UCLRadioViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>

@implementation UCLRadioViewController

@synthesize appDelegate;

- (void)setButtonImage:(UIImage *)image
{
	[button.layer removeAllAnimations];
	[button
		setImage:image
		forState:0];
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate getShows];
    nameOfTheShow.text = @"Not Currently Playing";
	UIImage *image = [UIImage imageNamed:@"playbutton.png"];
	[self setButtonImage:image];
    // Registers this class as the delegate of the audio session.
	[[AVAudioSession sharedInstance] setDelegate: self];
	
	NSError *myErr;
    
    Class twClass = NSClassFromString(@"TWTweetComposeViewController");
    if (!twClass){ // Framework not available, older iOS
        nameOfTheShow.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
    }
    
	
    // Initialize the AVAudioSession here.
	if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        // Handle the error here.
		NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
	}
    
}

    

- (void)spinButton {
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];

	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];

	[CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

- (IBAction)buttonPressed:(id)sender
{
	if (!streamer)
	{
		[textField resignFirstResponder];
		
			NSString *escapedValue =
				[(NSString *)CFURLCreateStringByAddingPercentEscapes(
					nil,
					(CFStringRef)[textField text],
					NULL,
					NULL,
					kCFStringEncodingUTF8)
				autorelease];

		NSURL *url = [NSURL URLWithString:escapedValue];
		streamer = [[AudioStreamer alloc] initWithURL:url];
		[streamer
			addObserver:self
			forKeyPath:@"isPlaying"
			options:0
			context:nil];
		[streamer start];

		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];

		[self spinButton];
       
        
	}
	else
	{
		[button.layer removeAllAnimations];
		[streamer stop];
        
        
	}
}


- (void) setNameOfTheProgram {
    if (!streamer) 
    { 
        nameOfTheShow.text = @"Not Currently Playing";
        
    }
    
    else {
    
    
    allShows = [[NSArray alloc]initWithArray:[appDelegate getShows]];
    // Support for TimeZone 
    NSDate *now = [NSDate date];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:now];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:now];
    NSTimeInterval interval = sourceGMTOffset - destinationGMTOffset ; 
    NSDate *today =[[NSDate alloc]initWithTimeInterval:interval sinceDate:now];    
    
    
    //Find what today's day of the week is 
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];    
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //find what time it is 
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:today];
    NSInteger hour = [[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[gregorian dateFromComponents:components]] hour];
    
        NSInteger nextUpweekday = weekday; 
        NSInteger nextUpHour = hour ;
    
    //Let's do this 
        
        for (int i=0; i < [allShows count]; i++){
            if ([[[allShows objectAtIndex:i]dayOfTheWeek] integerValue] == weekday) {
                
                if (hour >= [[[allShows objectAtIndex:i] startTime] integerValue] && hour <= [[[allShows objectAtIndex:i] endTime] integerValue]){
                    nameOfTheShow.text = [[allShows objectAtIndex:i]name];
                    nextUpHour = [[[allShows objectAtIndex:i]endTime]integerValue];
                    
                    
                    if ([[[allShows objectAtIndex:i] endTime] integerValue] == 23){
                        
                        nextUpHour = 00;
                        
                    }
                    
                    
                    if ([[[allShows objectAtIndex:i] endTime] integerValue] == 00){
                        if (weekday == 7){
                            nextUpweekday = 1;
                        }
                        else {nextUpweekday ++;}
                    }
                    
                    
                for (int j=0; i < [allShows count]; j++){
                    if ([[[allShows objectAtIndex:i]dayOfTheWeek] integerValue] == nextUpweekday) {
                        
                        if (nextUpHour == [[[allShows objectAtIndex:i] startTime] integerValue]){
                            
                            nextUp.text = [allShows objectAtIndex:j]; 
                     
                            
                        }
                    
                        
                    }

                    
                }
            
                
            }
            
        }
        
    }
        
}
}






- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
	change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"isPlaying"])
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		if ([(AudioStreamer *)object isPlaying])
		{
			[self
				performSelector:@selector(setButtonImage:)
				onThread:[NSThread mainThread]
				withObject:[UIImage imageNamed:@"stopbutton.png"]
				waitUntilDone:NO];
            [audioSession setActive:TRUE error:NULL];
            [self setNameOfTheProgram];
		}
		else
		{
			[streamer removeObserver:self forKeyPath:@"isPlaying"];
			[streamer release];
			streamer = nil;

			[self
				performSelector:@selector(setButtonImage:)
				onThread:[NSThread mainThread]
				withObject:[UIImage imageNamed:@"playbutton.png"]
				waitUntilDone:NO];
            
            [audioSession setActive:FALSE error:NULL];
             [self setNameOfTheProgram];
		}

		[pool release];
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change
		context:context];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
	[self buttonPressed:sender];
	return NO;
}

- (void)tweetButtonTapped:(id)sender {

    Class twClass = NSClassFromString(@"TWTweetComposeViewController");
    if (!twClass){ // Framework not available, older iOS
        
        UIAlertView *alert = [UIAlertView alloc];
        [alert initWithTitle:@"Update Required" message:@"This functionallity requires iOS 5.0 or higher." delegate: self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil , nil];
    
        [alert show];

    
    }
    if (twClass){ 
    NSURL *rareFMURL = [NSURL alloc];
    [rareFMURL initWithString:@"http://www.rarefm.co.uk/"];
    TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
    [tweetSheet setInitialText:@"I'm listening to RareFM. It rocks. Go ahead and download the app ! #UCLRadioApp"];
    [tweetSheet addURL:rareFMURL];
    [self presentModalViewController:tweetSheet animated:YES];
    }
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self buttonPressed:nil];
                break;
                
            default:
                break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


@end
