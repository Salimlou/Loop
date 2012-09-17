//
//  StoreState.m
//
//  Created by Brian Salinas on 8/30/12.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import "LoopDocument.h"

@implementation LoopDocument

@synthesize appState = _appState;
@synthesize delegate = _delegate;

- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName   // if more than 1 doc type
                   error:(NSError *__autoreleasing *)outError
{
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
    
    if ([dict.allKeys count] > 0) {
        _appState = [[NSMutableDictionary alloc] initWithDictionary:dict];
    } else  {
        _appState = [@{} mutableCopy];
    }
            
    [_delegate documentContentsUpdated:self];
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName
                error:(NSError *__autoreleasing *)outError
{
    if ([self.appState count] == 0) {
        // default values
        self.appState = [@{ tempoKey : @120.0 } mutableCopy];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.appState];
    return [NSData dataWithData:data];
}

@end
