//
//  Timeline.h
//  LoopIt
//
//  Created by Brian Salinas on 8/15/12.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Timeline : UIView

@property (readwrite, weak)UIColor *viewBackgroundColor;
@property (readwrite, weak)UIColor *tickHighlightColor;

- (void)highlightTick:(NSInteger)tick;
- (void)resetTimeline;

- (id)initWithFrame:(CGRect)frame
          stepCount:(int)stepCount;

@end
