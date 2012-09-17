//
//  BRTransport.m
//
//  Created by Brian Salinas on 7/22/11.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import "TransportView.h"

static NSString *playChar = @"d";
static NSString *pauseChar = @"k";
static NSString *stopChar = @"i";

@implementation TransportView {    
    UIButton *playPause_;
    UIButton *stop_;
	
	UIEdgeInsets playInset_;
	UIEdgeInsets pauseInset_;
}

@synthesize backdropColor = _backdropColor;
@synthesize iconTextColor = _iconTextColor;
@synthesize fontSize = _fontSize;
@synthesize state = _state;
@synthesize delegate = _delegate;

- (void)displayPlay
{
	playPause_.contentEdgeInsets = playInset_;
	[playPause_.titleLabel setFont:[UIFont fontWithName:@"LL_RECORD" size:self.fontSize + 20.0]];
	[playPause_ setTitle:playChar forState:UIControlStateNormal];
    self.state = PLAY_STATE;
}

- (void)displayPause
{
	playPause_.contentEdgeInsets = pauseInset_;
	[playPause_.titleLabel setFont:[UIFont fontWithName:@"LL_RECORD" size:self.fontSize + 12.0]];
	[playPause_ setTitle:pauseChar forState:UIControlStateNormal];
	self.state = PAUSE_STATE;
}

- (void)toggleControl:(UIButton *)sender
{
	switch (self.state) {
		case PAUSE_STATE:
			[self displayPlay];
			break;
		case PLAY_STATE:
			[self displayPause];
			break;
		default:
            NSAssert(NO, @"Unknown toggleControl choice in BRTransport");
			break;
	}
}

- (void)playOrPauseTouched
{
    [self.delegate playOrPauseClicked:self];
}

- (void)stopTouchDown
{
    [self.delegate stopClicked:self];
    [self displayPlay];
    [stop_ setTitleColor:[self.iconTextColor colorWithAlphaComponent:0.5]
               forState:UIControlStateNormal];
}

- (void)stopTouchUp
{
    [stop_ setTitleColor:self.iconTextColor forState:UIControlStateNormal];
}

#pragma mark Button creation

#define BORDER_WIDTH 8.0
#define BUTTON_WIDTH 70.0
- (void)buildPlayPauseButton
{
    CGRect rect = CGRectMake(1.0, 0.0, BUTTON_WIDTH, self.bounds.size.height + BORDER_WIDTH);
	
	playPause_ = [UIButton buttonWithType:UIButtonTypeCustom];
	playPause_.frame = rect;
	_state = PLAY_STATE;
	playPause_.contentEdgeInsets = playInset_;
	[playPause_ setTitleColor:self.iconTextColor forState:UIControlStateNormal];
	[playPause_.titleLabel setFont:[UIFont fontWithName:@"LL_RECORD" size:self.fontSize + 20.0]];
	[playPause_ setTitle:playChar forState:UIControlStateNormal];
	
	[playPause_ addTarget:self action:@selector(playOrPauseTouched) forControlEvents:UIControlEventTouchDown];
	// toggle state after messageing the external target.
	[playPause_ addTarget:self action:@selector(toggleControl:)forControlEvents:UIControlEventTouchDown];
	[self addSubview:playPause_];
}

- (void)buildStopButton
{
    CGRect rect = CGRectMake(BUTTON_WIDTH + 2.0,
                             0.0,
                             BUTTON_WIDTH,
                             self.bounds.size.height + BORDER_WIDTH);
	stop_ = [UIButton buttonWithType:UIButtonTypeCustom];
	stop_.frame = rect;
	stop_.contentEdgeInsets = UIEdgeInsetsMake(-12.0, 0.0, 0.0, 8.0);
	[stop_ setTitleColor:self.iconTextColor forState:UIControlStateNormal];
	[stop_.titleLabel setFont:[UIFont fontWithName:@"LL_RECORD" size:self.fontSize + 12.0]];
	[stop_ setTitle:stopChar forState:UIControlStateNormal];
	
	_state =  PAUSE_STATE;	// needed to set the correct state after stop is touched
	[stop_ addTarget:self action:@selector(stopTouchDown)forControlEvents:UIControlEventTouchDown];
    [stop_ addTarget:self action:@selector(stopTouchUp)forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	[self addSubview:stop_];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [playPause_.titleLabel setFont:[UIFont fontWithName:@"LL_RECORD" size:self.fontSize + 20.0]];
    [stop_.titleLabel setFont:[UIFont fontWithName:@"LL_RECORD" size:self.fontSize + 12.0]];
}

- (CGFloat)fontSize
{
    return _fontSize;
}

- (void)setIconTextColor:(UIColor *)color
{
	if (color != _iconTextColor) {
		_iconTextColor = color;
	}

	[playPause_ setTitleColor:self.iconTextColor forState:UIControlStateNormal];
	[stop_ setTitleColor:self.iconTextColor forState:UIControlStateNormal];
}

- (UIColor *)iconTextColor
{
    if (nil == _iconTextColor) {
        _iconTextColor = [UIColor whiteColor];
    }
    return _iconTextColor;
}

- (void)setBackdropColor:(UIColor *)color
{
	if (color != _backdropColor) {
		_backdropColor = color;
	}
	self.backgroundColor = _backdropColor;
}

- (UIColor *)backdropColor
{
    if (nil == _backdropColor) {
        _backdropColor = [UIColor clearColor];
    }
    return _backdropColor;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		playInset_ = UIEdgeInsetsMake(-14.0, 26.0, 0.0, 0.0);
		pauseInset_ = UIEdgeInsetsMake(-12.0, 12.0, 0.0, 0.0);
		
		[self buildPlayPauseButton];
        [self buildStopButton];
        self.state = PLAY_STATE;
    }
    return self;    
}

@end
