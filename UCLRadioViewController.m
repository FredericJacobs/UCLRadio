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

@synthesize appDelegate, playingRightNow;

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

	UIImage *image = [UIImage imageNamed:@"playbutton.png"];
	[self setButtonImage:image];
    // Registers this class as the delegate of the audio session.
	[[AVAudioSession sharedInstance] setDelegate: self];
	NSError *myErr;	
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
            [self updatePlayingNowLabel]; 
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
            
            
            [UIView animateWithDuration:0.6
                             animations:^{playingRightNow.alpha = 0;}];
            
            playingRightNow.text = @"Tune In !";
            
            [UIView animateWithDuration:1
                             animations:^{playingRightNow.alpha = 1;}];
               
            
		}

		[pool release];
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change
		context:context];
}

- (void) updatePlayingNowLabel {
    [UIView animateWithDuration:0.6
                     animations:^{playingRightNow.alpha = 0;}];
    
    playingRightNow.text =[appDelegate getShowName];

    [UIView animateWithDuration:1
                     animations:^{playingRightNow.alpha = 1;}];    
    
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
    NSURL *rareFMURL = [NSURL alloc];
    [rareFMURL initWithString:@"http://www.rarefm.co.uk/"];
    TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
    [tweetSheet setInitialText:@"I'm listening to RareFM. It rocks. Go ahead and download the app ! #UCLRadioApp"];
    [tweetSheet addURL:rareFMURL];
    [self presentModalViewController:tweetSheet animated:YES];
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
