//
//  ShowsParser.m
//  UCLRadio
//
//  Created by Frederic Jacobs on 12/12/11.
//  Copyright (c) 2011 EPFL. All rights reserved.
//

#import "ShowsParser.h"
#import "CocoaXMLParser.h"


@implementation ShowsParser

@synthesize myShowRSSParser , shows;


- (BOOL) getIsDoneParsing{
    
    return isDoneParsing; 
}

- (NSMutableArray *) getAllShows{
    return shows;
}
- (void)parserDidEndParsingData:(ShowRSSParser *)parser {
    self.myShowRSSParser = nil;
    isDoneParsing = YES ; 

}

- (void)parser:(ShowRSSParser *)parser didParseShows:(NSArray *)parsedShows{
    [shows addObjectsFromArray:parsedShows];
    
}

- (void) startParsing {
    [shows dealloc];
    shows = [[NSMutableArray alloc]init ];
    isDoneParsing = NO ;
    self.myShowRSSParser = [[[CocoaXMLParser alloc]init ]autorelease];
    myShowRSSParser.delegate = self ; 
    [myShowRSSParser start];
}



@end

