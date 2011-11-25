//
//  Show.h
//  UCLRadio
//
//  Created by Frederic Jacobs on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject {
    NSString *name;
    NSString *dayOfTheWeek;
    NSString *startTime;
    NSString *endTime;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *dayOfTheWeek;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

- (NSComparisonResult) compareWithAnotherShow:(Show*) anotherShow;


@end
