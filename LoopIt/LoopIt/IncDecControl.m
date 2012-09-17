//
//  IncDecControl.m
//
//  Created by Brian Salinas on 12/11/11.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import "IncDecControl.h"

@interface IncDecControl()
@property (readwrite, nonatomic, copy) EndTrackingBlock endTrackingBlock;
@end

@implementation IncDecControl {
    Float32 timerDuration;
    
    UILabel *label;
    NSTimer *timer;
    NSString *text;
}

@synthesize amount = _amount;
@synthesize iconTextColor = _iconTextColor;
@synthesize backdropColor = _backdropColor;
@synthesize fontSize = _fontSize;
@synthesize endTrackingBlock = _endTrackingBlock;
@synthesize delegate = _delegate;

- (void)createAdjustmentControl
{
	label = [[UILabel alloc] initWithFrame:self.bounds];
	[label setText:text];
	[label setFont:[UIFont fontWithName:@"AppleCasual" size:self.fontSize]];
	[label setTextColor:self.iconTextColor];
	[label setTextAlignment:UITextAlignmentCenter];
	label.backgroundColor = [UIColor clearColor];
	
	[self addSubview:label];
}

- (void)increment:(NSTimer*)theTimer
{
    [self.delegate valueChange:self];
}

- (void)incrementByHolding
{
	if (self.selected) {
		timer = [NSTimer scheduledTimerWithTimeInterval:timerDuration
													  target:self
													selector:@selector(increment:)
													userInfo:nil
													 repeats:YES];
	}
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super beginTrackingWithTouch:touch withEvent:event];
	[self.delegate valueChange:self];
	
	self.selected = YES;
	self.alpha = 0.5;
	[self performSelector:@selector(incrementByHolding) withObject:nil afterDelay:0.0];
	
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	
	self.selected = NO;
	self.alpha = 1.0;
	[timer invalidate];
    
    _endTrackingBlock();
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    [label setFont:[UIFont fontWithName:@"AppleCasual" size:_fontSize]];
}

- (CGFloat)fontSize
{
    if (_fontSize < 1) {
        _fontSize = 56.0;
    }
    return _fontSize;
}

- (void)setIconTextColor:(UIColor *)color
{
	if (color != _iconTextColor) 
		_iconTextColor = color;

	[label setTextColor:_iconTextColor];
}

- (UIColor *)iconTextColor
{
    if (nil == _iconTextColor) _iconTextColor = [UIColor grayColor];
    return _iconTextColor;
}

- (void)setBackdropColor:(UIColor *)color
{
	if (color != _backdropColor) 
		_backdropColor = color;
    
	label.backgroundColor = _backdropColor;
}

- (UIColor *)backdropColor
{
    if (nil == _backdropColor) _backdropColor = [UIColor clearColor];
    return _backdropColor;
}

- (id)initWithFrame:(CGRect)frame 
	  timerDuration:(Float32)duration 
			andType:(inc_dec_t)controlDirection
   endTrackingBlock:(EndTrackingBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
		text = controlDirection == IncControl ? @"+" : @"-";
		timerDuration = duration;
        _endTrackingBlock = block;
		
		[self createAdjustmentControl];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame
                 timerDuration:0.0
                       andType:IncControl
              endTrackingBlock:nil];
    if (self) {}
    return self;
}

@end
