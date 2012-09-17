//
//  Timeline.m
//  LoopIt
//
//  Created by Brian Salinas on 8/15/12.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import "Timeline.h"

static NSString *squareChar = @"i"; // LL_RECORD font mapping

@implementation Timeline
{
    int stepCount_;
    CGFloat stepWidth_;
    
    UIColor *tickColorLight_;
    UIColor *tickColorDark_;
    
    NSMutableSet *prevSteps_;
    NSSet *colorMap_;
    int currentTimelineNdx_;
}

@synthesize viewBackgroundColor = _viewBackgroundColor;
@synthesize tickHighlightColor = _tickHighlightColor;

- (void)buildLabels
{
    UILabel *tickLabel;
    for (int ndx = 0; ndx <stepCount_; ++ndx) {
        tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(ndx*stepWidth_,
                                                           -2.0,
                                                           stepWidth_,
                                                           self.frame.size.height + 2)];
        tickLabel.text = squareChar;
        tickLabel.font = [UIFont fontWithName:@"LL_RECORD" size:18.0];
        tickLabel.textColor = [colorMap_ containsObject:@(ndx + 1)] ? tickColorLight_ : tickColorDark_;
        tickLabel.textAlignment = UITextAlignmentCenter;
        tickLabel.backgroundColor = [UIColor clearColor];
        tickLabel.tag = ndx + 1;
        [self addSubview:tickLabel];
    }
}

- (void)resetTimeline
{
    // this implementation works because all the subviews are UILabels. This
    // would not work if any other object type was added as a subview.
    [self.subviews enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        label.textColor = [colorMap_ containsObject:@(idx + 1)] ? tickColorLight_ : tickColorDark_;
    }];
}

- (void)highlightTick:(NSInteger)tick
{
    [self resetTimeline];
    UILabel *label = [self.subviews objectAtIndex:tick - 1];
    label.textColor = _tickHighlightColor;
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
	if (viewBackgroundColor != _viewBackgroundColor) {
		_viewBackgroundColor = viewBackgroundColor;
        
        // same issues as commented in resetTimeline above
        [self.subviews enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger ndx, BOOL *stop) {
            label.backgroundColor =  _viewBackgroundColor;
        }];
	}
}

- (UIColor *)viewBackgroundColor
{
    return _viewBackgroundColor;
}

- (id)initWithFrame:(CGRect)frame
          stepCount:(int)stepCount
{
    self = [super initWithFrame:frame];
    if (self) {
        stepCount_ = stepCount;
        stepWidth_ = frame.size.width/stepCount_;
        prevSteps_ = [NSMutableSet new];
        tickColorLight_ = [UIColor grayColor];
        tickColorDark_ = [UIColor darkGrayColor];
        colorMap_ = [NSSet setWithArray:@[@1, @2, @3, @4, @9, @10, @11, @12]];
        
        [self buildLabels];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame stepCount:16];
    if (self) {}
    return self;
}

@end
