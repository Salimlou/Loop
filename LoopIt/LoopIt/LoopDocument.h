//
//  StoreState.h
//
//  Created by Brian Salinas on 8/30/12.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoopDocument;

static const NSString *tempoKey = @"tempo";

@protocol LoopDocumentDelegate <NSObject>
@required
- (void)documentContentsUpdated:(LoopDocument *)sender;

@end

@interface LoopDocument : UIDocument

@property (nonatomic, strong)NSMutableDictionary *appState;
@property (nonatomic, weak) id <LoopDocumentDelegate> delegate;

@end
