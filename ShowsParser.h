//
//  ShowsParser.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 12/12/11.
//  Copyright (c) 2011 EPFL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowRSSParser.h"

@interface ShowsParser : NSObject <ShowRSSParserDelegate> {
    ShowRSSParser *myShowRSSParser;
    NSMutableArray *shows;
    BOOL isDoneParsing;
}
@property (nonatomic, retain) NSMutableArray *shows;
@property (nonatomic, retain) ShowRSSParser *myShowRSSParser;

- (void) startParsing ;
- (BOOL) getIsDoneParsing; 
- (NSMutableArray *) getAllShows ; 

@end
