//
//  BRClock.h
//
//  Created by B Slnas on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Clock;

#pragma mark -
#pragma mark Clock protocols

@protocol ClockDelegate <NSObject>
@required
- (void)tick:(Clock *)clock;
@end

@interface Clock : NSObject 

@property (readonly, nonatomic, assign)UInt32 beat;
@property (readwrite, nonatomic, assign)Float32 tempo;
@property (readonly, nonatomic, assign)Float32 maxTempo;
@property (readonly, nonatomic, assign)Float32 minTempo;
@property (readonly)BOOL isRunning;
@property (nonatomic, weak) id <ClockDelegate> delegate;

- (void)play;
- (void)pause;
- (void)stop;

- (id)initWithTempo:(float)theTempo;

@end
