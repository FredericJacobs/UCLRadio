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

@end
