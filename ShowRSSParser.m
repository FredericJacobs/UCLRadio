//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



#import "ShowRSSParser.h"
#import "Show.h"

static NSUInteger kCountForNotification = 10;

@implementation ShowRSSParser

@synthesize delegate, parsedShows, startTimeReference, downloadStartTimeReference, parseDuration, downloadDuration, totalDuration;

+ (NSString *)parserName {
    NSAssert((self != [ShowRSSParser class]), @"Class method parserName not valid for abstract base class ShowRSSParser");
    return @"Base Class";
}

+ (XMLParserType)parserType {
    NSAssert((self != [ShowRSSParser class]), @"Class method parserType not valid for abstract base class ShowRSSParser");
    return XMLParserTypeAbstract;
}

- (void)start {
    self.startTimeReference = [NSDate timeIntervalSinceReferenceDate];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.parsedShows = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:@"http://www.fredericjacobs.com/rss.xml"];
    [NSThread detachNewThreadSelector:@selector(downloadAndParse:) toTarget:self withObject:url];
}

- (void)dealloc {
    [parsedShows release];
    [super dealloc];
}

- (void)downloadAndParse:(NSURL *)url {
    NSAssert([self isMemberOfClass:[ShowRSSParser class]] == NO, @"Object is of abstract base class ShowRSSParser");
}

- (void)downloadStarted {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    self.downloadStartTimeReference = [NSDate timeIntervalSinceReferenceDate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)downloadEnded {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - self.downloadStartTimeReference;
    downloadDuration += duration;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)parseEnded {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didParseShows:)] && [parsedShows count] > 0) {
        [self.delegate parser:self didParseShows:parsedShows];
    }
    [self.parsedShows removeAllObjects];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parserDidEndParsingData:)]) {
        [self.delegate parserDidEndParsingData:self];
    }
    NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
    totalDuration = duration;
    NSLog(@"Completed");
    
    
}

- (void)parsedShow:(Show *)Show {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [self.parsedShows addObject:Show];
    if (self.parsedShows.count > kCountForNotification) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didParseShows:)]) {
            [self.delegate parser:self didParseShows:parsedShows];
        }
        [self.parsedShows removeAllObjects];
    }
}

- (void)parseError:(NSError *)error {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [self.delegate parser:self didFailWithError:error];
    }
}

- (void)addToParseDuration:(NSNumber *)duration {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    parseDuration += [duration doubleValue];
}

@end
