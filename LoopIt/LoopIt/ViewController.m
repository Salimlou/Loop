//
//  ViewController.m
//  LoopIt
//
//  Created by Brian Salinas on 9/16/12.
//  Copyright (c) 2012 Bit Rhythmic Inc. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TransportView.h"
#import "TempoView.h"
#import "Timeline.h"
#import "Clock.h"
#import "LoopDocument.h"

@interface ViewController () <TransportDelegate, TempoDelegate, ClockDelegate, LoopDocumentDelegate>
@property (nonatomic)UIColor *appColor;
@property (nonatomic)UIColor *iconTextColor;
@end

@implementation ViewController
{
    UIToolbar *toolbar_;
    TransportView *transport_;
    TempoView *tempo_;
    Timeline *timeline_;
    Clock *clock_;
    
    LoopDocument *store_;
    NSURL *storeURL_;
    BOOL createFile_;
}

@synthesize appColor = _appColor;
@synthesize iconTextColor = _iconTextColor;

- (void)tick:(Clock *)clock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [timeline_ highlightTick:clock.beat];
    });
}

- (void)buildTimeline
{
#define SPACER 8.0
#define TIMELINE_HEIGHT 24.0
    CGFloat width = [[UIScreen mainScreen] applicationFrame].size.height - 2*SPACER;
    timeline_ = [[Timeline alloc] initWithFrame:CGRectMake(SPACER,
                                                           toolbar_.frame.size.height + 4.0,
                                                           width,
                                                           TIMELINE_HEIGHT)];
    timeline_.layer.cornerRadius = 4.0;
	timeline_.layer.edgeAntialiasingMask = YES;
	timeline_.layer.masksToBounds = YES;
	timeline_.clipsToBounds = YES;
    timeline_.viewBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
    timeline_.tickHighlightColor = self.appColor;
    
    [self.view addSubview:timeline_];
}

#pragma mark - TempoDelegate methods

- (void)adjustTempo:(TempoView *)tempoView;
{
    [clock_ setTempo:tempoView.value];
}

- (void)buildTempoControl
{
    // this is the transport xValue plus the width of the transport.
	CGFloat xValue = 306.0 - 42.0;
	tempo_= [[TempoView alloc] initWithFrame:CGRectMake(xValue, 320.0 - 64.0, 152.0, 60.0)
                                       tempo:tempo_.value
                                       title:@" bpm"
                            endTrackingBlock:^{
                                // only update the final tempo value when holding dow the
                                // inc or dec buttons
                                store_.appState = [@{ tempoKey : [NSNumber numberWithFloat:tempo_.value] } mutableCopy];
                                [store_ updateChangeCount:UIDocumentChangeDone];
                            }]; // space is needed to center
	tempo_.titleLabelColor = self.appColor;
    tempo_.iconTextColor = self.iconTextColor;
    tempo_.maxTempo = clock_.maxTempo;
    tempo_.minTempo = clock_.minTempo;
    tempo_.delegate = self;
    tempo_.hidden = YES;
}

#pragma mark - BRTransportDelegate

- (void)playOrPauseClicked:(TransportView *)sender
{
    sender.state == PLAY_STATE ? [clock_ play] : [clock_ pause];
}

- (void)stopClicked:(TransportView *)sender
{
    [clock_ stop];
    [timeline_ resetTimeline];
}

- (void)buildTransport
{
	transport_ = [[TransportView alloc] initWithFrame:CGRectMake(0.0, 0.0, 140.0, 64.0)];
	transport_.iconTextColor = self.iconTextColor;
    transport_.fontSize = 28.0;
    transport_.delegate = self;
    transport_.hidden = YES;
}

#pragma mark - Toolbar

// this will not work right if loaded in viewDidLoad, use viewWillAppear
- (void)buildToolbar
{
    [self buildTransport];
    [self buildTempoControl];
    
    CGRect rect = self.view.frame;
    rect.size = CGSizeMake(rect.size.height, 44.0);
    toolbar_ = [[UIToolbar alloc] initWithFrame:rect];
    toolbar_.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *transportItem = [[UIBarButtonItem alloc] initWithCustomView:transport_];
    UIBarButtonItem *tempoItem = [[UIBarButtonItem alloc] initWithCustomView:tempo_];
    
    //Use this to put space in between your toolbar buttons
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width = 12.0;
    NSArray *items = @[fixedSpace, tempoItem, flexSpace, transportItem, fixedSpace];
    
    [toolbar_ setItems:items animated:NO];
    [self.view addSubview:toolbar_];
}

#pragma mark - Color properties

- (UIColor *)appColor
{
    if (nil == _appColor) {
        _appColor = [UIColor orangeColor];
    }
    return _appColor;
}

- (UIColor *)iconTextColor
{
    if (nil == _iconTextColor) {
        _iconTextColor = [UIColor lightGrayColor];
    }
    return _iconTextColor;
}

#pragma mark - StoreStateDelegate Methods

- (void)documentContentsUpdated:(LoopDocument *)sender
{
    // right now we are not doing anything here
}

-(NSURL*)localDocumentsDirectoryURL
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"store.dcmt"];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    createFile_ = ![filemgr fileExistsAtPath: dataFile];
    
    return [NSURL fileURLWithPath:dataFile];
}

- (void)openStoreDocument
{
    storeURL_ = [self localDocumentsDirectoryURL];
    store_ = [[LoopDocument alloc] initWithFileURL:storeURL_];
    store_.delegate = self;
    
    void (^displayViews)(BOOL);
    displayViews = ^(BOOL success) {
        if (success){
            tempo_.value = [[store_.appState objectForKey:tempoKey] floatValue];
            tempo_.hidden = NO;
            transport_.hidden = NO;
        }
    };
    
    if (createFile_){
        [store_ saveToURL:storeURL_
         forSaveOperation: UIDocumentSaveForCreating
        completionHandler:displayViews];
        createFile_ = NO;
    } else {
        [store_ openWithCompletionHandler:displayViews];
    }
}

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    clock_ = [Clock new];
    clock_.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self openStoreDocument];
    [self buildToolbar];
    [self buildTimeline];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    store_ = nil;
    storeURL_ = nil;
    toolbar_ = nil;
    transport_ = nil;
    tempo_ = nil;
    timeline_ = nil;
    clock_ = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [store_ closeWithCompletionHandler:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
