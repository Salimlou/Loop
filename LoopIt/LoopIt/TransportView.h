//
//  BRTransport.h
//
//  Created by Brian Salinas on 7/22/11.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	PLAY_STATE = 1,
	PAUSE_STATE
}transport_t;

@class TransportView;

@protocol TransportDelegate 
- (void)playOrPauseClicked:(TransportView *)sender;
- (void)stopClicked:(TransportView *)sender;
@end

@interface TransportView : UIView 

@property (readwrite, nonatomic, weak)UIColor *iconTextColor;
@property (readwrite, nonatomic, weak)UIColor *backdropColor;
@property (readwrite, nonatomic) CGFloat fontSize;
@property (readwrite, nonatomic) transport_t state;
@property (nonatomic, weak) id <TransportDelegate> delegate;

- (void)displayPlay;
- (void)displayPause;

@end
