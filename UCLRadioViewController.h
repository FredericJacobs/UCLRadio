//
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

#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"



@class AudioStreamer;

@interface UCLRadioViewController : UIViewController
{
	IBOutlet UITextField *textField;
	IBOutlet UIButton *button;
	AudioStreamer *streamer;
    IBOutlet UIButton *tweetThis;
    AVAudioSession *audioSession;
    AppDelegate *appDelegate;
    IBOutlet UILabel *playingRightNow;
}

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UILabel *playingRightNow;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)tweetButtonTapped: (id) sender;
- (void) updatePlayingNowLabel;


@end

