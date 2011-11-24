//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMLParserTypeAbstract = -1,
    XMLParserTypeNSXMLParser = 0,
    XMLParserTypeLibXMLParser
} XMLParserType;

@class ShowRSSParser, Show;

// Protocol for the parser to communicate with its delegate.
@protocol ShowRSSParserDelegate <NSObject>

@optional
// Called by the parser when parsing is finished.
- (void)parserDidEndParsingData:(ShowRSSParser *)parser;
// Called by the parser in the case of an error.
- (void)parser:(ShowRSSParser *)parser didFailWithError:(NSError *)error;
// Called by the parser when one or more Shows have been parsed. This method may be called multiple times.
- (void)parser:(ShowRSSParser *)parser didParseShows:(NSArray *)parsedShows;

@end


@interface ShowRSSParser : NSObject {
    id <ShowRSSParserDelegate> delegate;
    NSMutableArray *parsedShows;
    // This time interval is used to measure the overall time the parser takes to download and parse XML.
    NSTimeInterval startTimeReference;
    NSTimeInterval downloadStartTimeReference;
    double parseDuration;
    double downloadDuration;
    double totalDuration;
}

@property (nonatomic, assign) id <ShowRSSParserDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *parsedShows;
@property NSTimeInterval startTimeReference;
@property NSTimeInterval downloadStartTimeReference;
@property double parseDuration;
@property double downloadDuration;
@property double totalDuration;

+ (NSString *)parserName;
+ (XMLParserType)parserType;

- (void)start;

// Subclasses must implement this method. It will be invoked on a secondary thread to keep the application responsive.
// Although NSURLConnection is inherently asynchronous, the parsing can be quite CPU intensive on the device, so
// the user interface can be kept responsive by moving that work off the main thread. This does create additional
// complexity, as any code which interacts with the UI must then do so in a thread-safe manner.
- (void)downloadAndParse:(NSURL *)url;

// Subclasses should invoke these methods and let the superclass manage communication with the delegate.
// Each of these methods must be invoked on the main thread.
- (void)downloadStarted;
- (void)downloadEnded;
- (void)parseEnded;
- (void)parsedShow:(Show *)Show;
- (void)parseError:(NSError *)error;
- (void)addToParseDuration:(NSNumber *)duration;

@end
