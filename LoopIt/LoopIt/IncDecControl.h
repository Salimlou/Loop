//
//  IncDecControl.h
//
//  Created by B Slnas on 12/11/11.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncDecControl;
typedef void(^EndTrackingBlock)(void);

typedef enum {
	IncControl,
	DecControl
} inc_dec_t;

@protocol IncDecControlDelegate
@optional
- (void)valueChange:(IncDecControl *)sender;
@end

@interface IncDecControl : UIControl 

@property (readwrite, nonatomic)float amount;
@property (readwrite, nonatomic, strong)UIColor *iconTextColor;
@property (readwrite, nonatomic, strong)UIColor *backdropColor;
@property (readwrite, nonatomic)CGFloat fontSize;
@property (nonatomic, weak) id <IncDecControlDelegate> delegate;

- (id)initWithFrame:(CGRect)frame 
	  timerDuration:(Float32)duration 
			andType:(inc_dec_t)controlDirection
   endTrackingBlock:(EndTrackingBlock)block;

@end
