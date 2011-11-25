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

- (void)setButtonImage:(UIImage *)image
{
	[button.layer removeAllAnimations];
	[button
		setImage:image
		forState:0];
}

- (void)viewDidLoad
{
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
- (void) setNameOfTheProgramToNill {
    
    nameOfTheShow.text = @"Not Currently Playing";
    
}

- (void) setNameOfTheProgram {
    NSDate *today = [NSDate date];
    
    //Find what today's day of the week is 
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    int weekday = [weekdayComponents weekday];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //find what time it is 
    NSDateComponents *components = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:today];
    NSInteger hour = [components hour];
    
    NSLog(@"%d",hour);
    
    //Let's do this 
    
    if (weekday == 1){ 
        // Sunday 
        
        if (hour == 0){
            
            nameOfTheShow.text = @"Jack & Cameron";
            
        }
        
        if (0<hour<10) {
            
            nameOfTheShow.text = @"Exposure";
            
        }
        
        if (hour == 10){
            
            nameOfTheShow.text = @"The Dour Hour";
            
        }
        
        if (hour == 11){
            nameOfTheShow.text = @"Oli S.";
        }
        
        if (hour == 12){
            nameOfTheShow.text = @"Conference of the Birds";
        }
        
        if (hour == 13){
            
            nameOfTheShow.text = @"Cream";
        }
        
        if (hour == 14){
            nameOfTheShow.text = @"The World Music Show ";
        }
        
        if (hour == 15){
            
            nameOfTheShow.text = @"Music ABC";
        }
        
        if (16 <= hour < 18){
            
            nameOfTheShow.text = @"SRA Chart";
        }
        
        if (hour == 18){
            nameOfTheShow.text= @"Slow Centuries";
        }
        
        if (hour == 19){
            nameOfTheShow.text=@"Richard Close";
            
        }
        
        if (hour == 20) {
            nameOfTheShow.text = @"Kris and Ally's Weekend Wondershow";
        }
        
        if (hour == 21){
            nameOfTheShow.text = @"The Sunday Show "; 
            
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"The Crease";
        }
        
        if (hour == 23){
            
            nameOfTheShow.text = @"Easy Skankin'";
        }
        
        
        
    }
    
    if (weekday == 2){ // Monday
        
        if (hour == 0){
            
            nameOfTheShow.text = @"The Boring Student";
            
        }
        
        if (0<hour<10) {
            
            nameOfTheShow.text = @"Euan";
            
        }
        
        if (10<= hour < 12){
            
            nameOfTheShow.text = @"Sonti";
            
        }
        
        if (12 <= hour < 14 ) {
            
            nameOfTheShow.text = @"Taking the P";
        }
        
        if (14 <= hour < 16){
            
            nameOfTheShow.text = @"Miles Beckswith";
            
        }
        
        if (16<= hour < 18 ) {
            
            nameOfTheShow.text = @"Alex & Bella";
            
        }
        
        if (18 <= hour < 20){
            
            nameOfTheShow.text = @"We Are Your Friends";
        }
        
        if (hour == 20) {
            
            nameOfTheShow.text = @"TPB";
            
        }
        
        if (hour == 21){
            
            nameOfTheShow.text = @"Nodal Points";
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"The Oli Show";
        }
        
        if (hour == 23)
        {
            
            nameOfTheShow.text = @"Robert Heath";
        }
        
        
        
        
    }
    
    
    
    
    
    if (weekday == 3){
        
        if (hour == 0){
            
            nameOfTheShow.text = @"Tropical Hour";
            
        }
        
        if (0<hour<10) {
            
            nameOfTheShow.text = @"The Confiture";
            
        }
        if (10<= hour < 12){
            
            nameOfTheShow.text = @"The not so BBC Radio 1 Show";
            
        }
        
        if (12 <= hour < 14 ) {
            
            nameOfTheShow.text = @"Jessica Thornhill";
        }
        
        if (14 <= hour < 16){
            
            nameOfTheShow.text = @"Thomas Smith";
            
        }
        
        if (16<= hour < 18 ) {
            
            nameOfTheShow.text = @"Holly Harris";
            
        }
        
        if (18 <= hour < 20){
            
            nameOfTheShow.text = @"Enter Safari";
        }
        
        if (hour == 20) {
            
            nameOfTheShow.text = @"Unplanned Project";
            
        }
        
        if (hour == 21){
            
            nameOfTheShow.text = @"Ali Murray";
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"Sub Bass Show";
        }
        
        if (hour == 23)
        {
            
            nameOfTheShow.text = @"Andrej Hagan";
        }
        
        
        
        
        
    }// Tuesday 
    
    if (weekday == 4){
        
        if (hour == 0){
            
            nameOfTheShow.text = @"UCLBass";
            
        }
        
        if (0<hour<12) {
            
            nameOfTheShow.text = @"Late Night with Dave";
            
        }
        if (12 <= hour < 14 ) {
            
            nameOfTheShow.text = @"PFEV/Hana White";
        }
        
        if (14 <= hour < 16){
            
            nameOfTheShow.text = @"Chat In The Hat";
            
        }
        
        if (16<= hour < 18 ) {
            
            nameOfTheShow.text = @"Popfixed";
            
        }
        
        if (18 <= hour < 20){
            
            nameOfTheShow.text = @"Jules Moscovici";
        }
        
        if (hour == 20) {
            
            nameOfTheShow.text = @"Rock Your Heart Out";
            
        }
        
        if (hour == 21){
            
            nameOfTheShow.text = @"Frenchie Time";
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"Musical Jumpers";
        }
        
        if (hour == 23)
        {
            
            nameOfTheShow.text = @"Seasick";
        }
        
        
        
        
    }// Wednesday
    
    if (weekday == 5){
        
        if (hour == 0){
            
            nameOfTheShow.text = @"The Noise Problem";
            
        }
        
        if (0<hour<10) {
            
            nameOfTheShow.text = @"Joe Buckingham";
        }
        
        if (10<= hour < 12){
            
            nameOfTheShow.text = @"Tamara Habayeb";
            
        }
        
        if (12 <= hour < 14 ) {
            
            nameOfTheShow.text = @"Toby Coulthard";
        }
        
        if (14 <= hour < 16){
            
            nameOfTheShow.text = @"Han Solo";
            
        }
        
        if (16<= hour < 18 ) {
            
            nameOfTheShow.text = @"Grace Regan";
            
        }
        
        if (18 <= hour < 20){
            
            nameOfTheShow.text = @"Will & Josh";
        }
        
        if (hour == 20) {
            
            nameOfTheShow.text = @"Tortoise on the Tom";
            
        }
        
        if (hour == 21){
            
            nameOfTheShow.text = @"Let Me Share With You : Evening with Will Rowland";
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"Really Reel";
        }
        
        if (hour == 23)
        {
            
            nameOfTheShow.text = @"DJ Dibbs";
        }
        
        
        
        
    }// Thursday
    
    if (weekday == 6){
        
        if (hour == 0){
            
            nameOfTheShow.text = @"Lu and Em";
            
        }
        
        if (0<hour<10) {
            
            nameOfTheShow.text = @"Soul Stew";
        }
        
        if (10<= hour < 12){
            
            nameOfTheShow.text = @"Zoe Edwards";
            
        }
        
        if (12 <= hour < 14 ) {
            
            nameOfTheShow.text = @"Sine Language with Radio Luke";
        }
        
        if (14 <= hour < 16){
            
            nameOfTheShow.text = @"Adam Townsend";
            
        }
        
        if (16<= hour < 18 ) {
            
            nameOfTheShow.text = @"Ritika Gupta";
            
        }
        
        if (18 <= hour < 20){
            
            nameOfTheShow.text = @"EarGasm";
        }
        
        if (hour == 20) {
            
            nameOfTheShow.text = @"Frankie Frost Live";
            
        }
        
        if (hour == 21){
            
            nameOfTheShow.text = @"Jesse Peacock and Friends";
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"A Night In Night Out";
        }
        
        if (hour == 23)
        {
            
            nameOfTheShow.text = @"Another Late Night";
        }
        
        
        
        
    }// Friday
    
    if (weekday == 7){
        
        if (hour == 0){
            
            nameOfTheShow.text = @"Essential Mix";
            
        }
        
        if (0<hour<10) {
            
            nameOfTheShow.text = @"Sam Shears";
        }
        
        if (hour == 10){
            
            nameOfTheShow.text = @"The Classical Hour";
            
        }
        
        if (hour == 11){
            nameOfTheShow.text = @"Full Circle";
        }
        
        if (hour == 12){
            nameOfTheShow.text = @"Medium Rare";
        }
        
        if (hour == 13){
            
            nameOfTheShow.text = @"Reaching Dangerous Levels of Sobriety";
        }
        
        if (hour == 14){
            nameOfTheShow.text = @"The Rare Jazz Show";
        }
        
        if (15 <= hour < 16){
            
            nameOfTheShow.text = @"Film Show";
        }
        
        if (hour == 17){
            
            nameOfTheShow.text = @"Reviews";
        }
        
        if (hour == 18){
            nameOfTheShow.text= @"Nimesh";
        }
        
        if (hour == 19){
            nameOfTheShow.text=@"Tomas Stephens";
            
        }
        
        if (hour == 20) {
            nameOfTheShow.text = @"Hip Hop vs Indie Pop";
        }
        
        if (hour == 21){
            nameOfTheShow.text = @"Johnthan Wilson"; 
            
        }
        
        if (hour == 22){
            
            nameOfTheShow.text = @"Switch It Up & Edvard Nore";
        }
        
        if (hour == 23){
            
            nameOfTheShow.text = @"Ed and Al's Footy Show";
        }
        
        
    }// Saterday
    
    else 
        NSLog(@"Fail to initiate date");


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
             [self setNameOfTheProgramToNill];
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
        
        UIAlertView *alert = [[UIAlertView alloc] autorelease];
        [alert initWithTitle:@"Update Required" message:@"This functionallity requires iOS 5.0 or higher." delegate: self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil , nil];
    
        [alert show];

    
    }
    if (twClass){ 
    NSURL *rareFMURL = [[NSURL alloc] autorelease];
    [rareFMURL initWithString:@"http://www.rarefm.co.uk/"];
    TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
    [tweetSheet setInitialText:@"I'm listening to RareFM. It rocks. Go ahead and download the app ! "];
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
