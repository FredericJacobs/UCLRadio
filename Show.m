//
//  Show.m
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Show.h"

@implementation Show

@synthesize name, endTime, startTime,dayOfTheWeek;

- (NSComparisonResult) compareWithAnotherShow:(Show*) anotherShow{
   
   return [[self name] compare:[anotherShow name]];
}

+ (NSString *) toString: (Show *)aShow{
    
    NSString *stringToReturn = [[[[[[[aShow name] stringByAppendingString:@" ; "] stringByAppendingString:[aShow startTime]]stringByAppendingString:@" ; " ]stringByAppendingString:[aShow endTime]]stringByAppendingString:@" ; "]stringByAppendingString:[aShow dayOfTheWeek]];
    NSLog(@"%@", stringToReturn);
    return stringToReturn;

}

+ (Show *) fromString : (NSString*) aString{
    
    Show *newShow = [[self alloc] init];
    NSArray * myArray;
    myArray = [NSArray arrayWithArray:[aString componentsSeparatedByString:@" ; "]];
    NSLog(@"%@", [myArray objectAtIndex:0]);
    newShow.name = [myArray objectAtIndex:0];
    newShow.startTime = [myArray objectAtIndex:1];
    newShow.endTime = [myArray objectAtIndex:2];
    newShow.dayOfTheWeek = [myArray objectAtIndex:3];
    
    return newShow;
}


@end
