//
//  BRClock.m
//
//  Created by B Slnas on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Clock.h"

#pragma mark -
#pragma mark static constants

static const Float32 kMaxTempo = 300.0;
static const Float32 kMinTempo = 20.0;
static const Float32 Q_96_NOTE = 15.0;

@implementation Clock
{
    NSThread *clockThread_;
    int  loopBitArray_;
    int  resetBitArray_;
    
    CGFloat timeDiv_;
}

@synthesize beat = _beat;
@synthesize tempo = _tempo;
@synthesize isRunning = _isRunning;
@synthesize delegate = _delegate;

/*
 * This implementation is watered down from a version that has a lot more
 * responsibility. That is why beat is not just incremented and modded
 * with 16. 
 */
- (void)setBeat:(UInt32)beat
{
    if (!loopBitArray_){
        // flipping bit is faster than assignment
        loopBitArray_ |= resetBitArray_;
        _beat = 1;
    }
    
    [self.delegate tick:self];
    loopBitArray_ = loopBitArray_ >>= 1;
}

#pragma mark Tempo Methods

- (void)setTempo:(Float32)tempo {
    // Make sure tempo is withing the max and min range
    if (tempo >= kMaxTempo) {
        tempo = kMaxTempo;
    } else if (tempo <= kMinTempo) {
        tempo = kMinTempo;
    }
    
	_tempo = tempo;
    timeDiv_ = Q_96_NOTE/_tempo;
}

- (Float32)tempo
{
	return _tempo;
}

- (Float32)maxTempo
{
	return kMaxTempo;
}

- (Float32)minTempo
{
	return kMinTempo;
}

#pragma mark - Thread methods

- (void)startClockTimer:(id)info
{
    @autoreleasepool {
        // Give sound thread high priority to keep the timing steady
        [NSThread setThreadPriority:1.0];
        BOOL continuePlaying = YES;
        
        while (continuePlaying) {  // loop until cancelled
            // Use an autorelease pool to prevent the build-up of temporary date objects
            @autoreleasepool {
                [self setBeat:++_beat];
                
                NSDate *curtainTime = [NSDate dateWithTimeIntervalSinceNow:timeDiv_];
                NSDate *currentTime = [NSDate date];
                
                // wake up periodically to see if we've been cancelled
                while (continuePlaying && ([currentTime compare:curtainTime] != NSOrderedDescending)) { 
                    if ([clockThread_ isCancelled] == YES) {
                        continuePlaying = NO;
                    }
                    [NSThread sleepForTimeInterval:0.001];
                    currentTime = [NSDate date];
                }
            }
        }
    }
}

- (void)waitForClockThreadToFinish
{
    while (clockThread_ && ![clockThread_ isFinished]) { // wait for the thread to finish
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)startClockThread
{
    if (clockThread_ != nil) [self stopClockThread];
    
    clockThread_ = [[NSThread alloc] initWithTarget:self
                                           selector:@selector(startClockTimer:)
                                             object:nil];
    
    [clockThread_ setName:[NSString stringWithFormat:@"%@-Thread", [[self class] description]]];
    [clockThread_ setName:@"Clock Thread"];
    [clockThread_ start];
}

- (void)stopClockThread
{
    [clockThread_ cancel];
    [self waitForClockThreadToFinish];
    clockThread_ = nil;
}

- (void)play
{
	[self startClockThread];
    _isRunning = YES;
}

- (void)pause
{
	[self stopClockThread];
    _isRunning = NO;
}

- (void)stop
{
	[self stopClockThread];
    // reset the state
    loopBitArray_ = resetBitArray_;
    _beat = 0;
    _isRunning = NO;
}

- (id)initWithTempo:(float)tempo
{	
    if ((self = [super init])){	        
        // tempo and timeDiv has to be set as a pair
        _tempo = tempo;
        timeDiv_ = Q_96_NOTE/_tempo;
        _beat = 0;
        
#define MAX_RESOLUTION 0xFFFF // set 16 bits on
        resetBitArray_ = MAX_RESOLUTION;
    }
	
    return self;
}

- (id)init
{
    if (self = [self initWithTempo:120.0]){
    }
    return self;
}

@end
