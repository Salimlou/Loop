//
//  TempoControl.m
//
//  Created by Brian Salinas on 7/15/11.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import "IncDecControl.h"
#import "TempoView.h"

static float fontSize;

@interface TempoView() <IncDecControlDelegate>
@property (readwrite, nonatomic, copy) EndTrackingBlock endTrackingBlock;
@end

@implementation TempoView
{
    UILabel *titleLabel_;
    UILabel *valueLabel_;
    NSString *titleText_;
}

@synthesize titleLabelColor = _titleLabelColor;
@synthesize iconTextColor = _iconTextColor;
@synthesize backdropColor = _backdropColor;
@synthesize value = _value;
@synthesize minTempo = _minTempo;
@synthesize maxTempo = _maxTempo;
@synthesize endTrackingBlock = _endTrackingBlock;
@synthesize delegate = _delegate;

+ (void)initialize
{
    fontSize = 14.0;
}

- (void)setBorders
{
#define BORDER_WIDTH 4.0
	[self setBounds:CGRectMake(BORDER_WIDTH,
							   BORDER_WIDTH, 
							   self.bounds.size.width - BORDER_WIDTH, 
							   self.bounds.size.height - BORDER_WIDTH)];
}

- (void)createAdjustmentControls
{
	CGRect decRect = CGRectMake(4.0, 8.0, 46.0, 46.0);
	Float32 timerDuration = 0.15;
#define BUTTON_COUNT 2
    // this will be the amount to inc or dec by.
    int incDecValues[BUTTON_COUNT] = {-1, 1};
    inc_dec_t buttonType[BUTTON_COUNT] = {DecControl, IncControl};
    
    IncDecControl *controlButton;
    for (int ndx = 0; ndx < BUTTON_COUNT; ndx++) {
        controlButton = [[IncDecControl alloc] initWithFrame:decRect
                                               timerDuration:timerDuration
                                                     andType:buttonType[ndx]
                                            endTrackingBlock:self.endTrackingBlock];
        controlButton.iconTextColor = self.iconTextColor;
        controlButton.amount = incDecValues[ndx];	
        controlButton.clipsToBounds = YES;
        controlButton.delegate = self;
        [self addSubview:controlButton];
        decRect.origin = CGPointMake(self.bounds.size.width - decRect.size.width + 4.0,
                                     decRect.origin.y - 2.0);
    }
    
}

- (void)createTitleLabel
{
	CGFloat width = 54.0;
	CGFloat height = 24.0;
	CGFloat x = self.bounds.size.width - width - 43.0;
	CGFloat y = (self.bounds.size.height - height - 4.0);
	
    titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
	titleLabel_.backgroundColor = [UIColor clearColor];
	titleLabel_.textColor = self.titleLabelColor;
	titleLabel_.text = titleText_;
	titleLabel_.font = [UIFont systemFontOfSize:fontSize];
	titleLabel_.textAlignment = UITextAlignmentCenter;
	titleLabel_.opaque = YES;
		
	[self addSubview:titleLabel_];
}

- (void)setValue:(Float32)value
{
	_value = value;
	valueLabel_.text = [NSString stringWithFormat:@"%.1f\n\n", _value];
}

- (void)valueChange:(IncDecControl *)sender
{
	_value += sender.amount;
	_value = floor(_value);
	
	if (_value < _minTempo) {
		_value = _minTempo;
	} else if (_value > _maxTempo) {
		_value = _maxTempo;
	}
    
    [self.delegate adjustTempo:self];
	[self setValue:floor(_value)];
}

- (void)createValueLabel
{
	CGFloat width = 54.0;
	CGFloat height = 42.0;
	CGFloat x = self.bounds.size.width - width - 43.0;
	CGFloat y = (self.bounds.size.height - height - 2.0);
	
	valueLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
	valueLabel_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
	valueLabel_.textColor = [UIColor whiteColor];
	valueLabel_.font = [UIFont systemFontOfSize:fontSize];
	valueLabel_.textAlignment = UITextAlignmentCenter;
	valueLabel_.numberOfLines = 2;	// So I can place the value in upper part of the label.
	valueLabel_.opaque = YES;
	
	[self addSubview:valueLabel_];	
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
	if (titleLabelColor != _titleLabelColor) {
		_titleLabelColor = titleLabelColor;
	}
    titleLabel_.textColor = _titleLabelColor;
}

- (UIColor *)titleLabelColor
{
    if (nil == _titleLabelColor) {
        _titleLabelColor = [UIColor redColor];
    }
    return _titleLabelColor;
}

- (void)setIconTextColor:(UIColor *)color
{
	if (color != _iconTextColor) {
		_iconTextColor = color;
	}
}

- (UIColor *)iconTextColor
{
    if (nil == _iconTextColor) {
        _iconTextColor = [UIColor lightGrayColor];
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
        _backdropColor = [UIColor darkGrayColor];
    }
    return _backdropColor;
}

- (id)initWithFrame:(CGRect)frame
			  tempo:(Float32)tempo
			  title:(NSString *)titleText
   endTrackingBlock:(EndTrackingBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
		titleText_ = titleText;
        _minTempo = 60.0;
        _maxTempo = 260.0;
        _endTrackingBlock = block;
		
		[self setBorders];
		[self createValueLabel];
		// this call must happen after the labels are created with above call.
		[self setValue:tempo];
		[self createAdjustmentControls];
		[self createTitleLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame
						 tempo:120.0
						 title:@" bpm"
              endTrackingBlock:nil];
    if (self) {}
    return self;
}

@end
