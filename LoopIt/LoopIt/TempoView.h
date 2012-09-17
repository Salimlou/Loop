//
//  TempoControl.h
//
//  Created by Brian Salinas on 7/15/11.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncDecControl.h"

@class TempoView;

@protocol TempoDelegate
@optional
- (void)adjustTempo:(TempoView *)tempoView;
@end

@interface TempoView : UIView

@property (readwrite, nonatomic, strong)UIColor *titleLabelColor;
@property (readwrite, nonatomic, strong)UIColor *iconTextColor;
@property (readwrite, nonatomic, strong)UIColor *backdropColor;
@property (readwrite, nonatomic, assign)Float32 value;
@property (readwrite, nonatomic, assign)Float32 minTempo;
@property (readwrite, nonatomic, assign)Float32 maxTempo;
@property (weak) id <TempoDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
			  tempo:(Float32)tempo
			  title:(NSString *)titleText
   endTrackingBlock:(EndTrackingBlock)block;

- (void)setValue:(Float32)value;

@end
