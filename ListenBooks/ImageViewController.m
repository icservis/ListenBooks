//
//  ImageViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageViewController.h"
#import "ProgressWindowController.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"

@interface ImageViewController ()

@property (strong) NSMutableArray *data;
@property (assign) id initialSelectedObject;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *sideBarView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *pageLabel;
@property (weak) IBOutlet NSView *pageView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatior;
@property (weak) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;

@end

@implementation ImageViewController {
    CGFloat _toolBarFrameHeight;
    CGFloat _sideBarViewWidth;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadPageContent];
    
    _toolBarFrameHeight = self.toolBarView.frame.size.height;
    _sideBarViewWidth = self.sideBarView.frame.size.width;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.initialSelectedObject = nil;
}


- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    
    self.initialSelectedObject = nil;
    [[self.pageView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[NSProgressIndicator class]]) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)loadPageContent
{
    DDLogVerbose(@"setupImagePageControllerContent");
    NSURL *dirURL = [[NSBundle mainBundle] resourceURL];
    
    // load all the necessary image files by enumerating through the bundle's Resources folder,
    // this will only load images of type "kUTTypeImage"
    //
    [self.progressIndicatior startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        
        self.data = [[NSMutableArray alloc] initWithCapacity:1];
        
        NSDirectoryEnumerator *itr = [[NSFileManager defaultManager] enumeratorAtURL:dirURL includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLLocalizedNameKey, NSURLEffectiveIconKey, NSURLIsDirectoryKey, NSURLTypeIdentifierKey, nil] options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
        
        for (NSURL *url in itr) {
            NSString *utiValue;
            [url getResourceValue:&utiValue forKey:NSURLTypeIdentifierKey error:nil];
            
            if (UTTypeConformsTo((__bridge CFStringRef)(utiValue), kUTTypeImage)) {
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
                [self.data addObject:image];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.pageController setArrangedObjects:self.data];
            [self.progressIndicatior stopAnimation:nil];
        });
    });
}

#pragma mark - TabViewControllerProtocol

- (void)toggleToolBar
{
    if ([[self.toolBarHeightConstraint animator] constant] > 0) {
        [[self.toolBarHeightConstraint animator] setConstant:0];
    } else {
        [[self.toolBarHeightConstraint animator] setConstant:_toolBarFrameHeight];
    }
}

- (BOOL)isToolBarOpened
{
    return (self.sideBarView.frame.size.height > 0) ? YES:NO;
}

- (void)toggleSideBar
{
    [self.splitView adjustSubviews];
    if ([self.splitView isSubviewCollapsed:self.sideBarView] == NO) {
        [self.splitView setPosition:0 ofDividerAtIndex:0];
    } else {
        [self.splitView setPosition:_sideBarViewWidth ofDividerAtIndex:0];
    }
}

- (BOOL)isSideBarOpened
{
    return ![self.splitView isSubviewCollapsed:self.sideBarView];
}

#pragma mark - PageControllerDelegate

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    return @"picture";
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier {
    return [[NSViewController alloc] initWithNibName:@"ImageView" bundle:nil];
}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object {
    // viewControllers may be reused... make sure to reset important stuff like the current magnification factor.
    
    self.pageLabel.stringValue = [NSString stringWithFormat:@"%@: %li / %li", NSLocalizedString(@"Page", nil), (long)pageController.selectedIndex+1, [self.pageController.arrangedObjects count]];
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        [(NSScrollView*)viewController.view setMagnification:1.0];
    }
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController {
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([splitView isEqualTo:self.splitView] && [subview isEqualTo:self.contentView]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
    BOOL result = NO;
    if ([splitView isEqualTo:self.splitView]) {
        result = YES;
    }
    return result;
}

- (void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    NSSplitView* splitView = (NSSplitView*)notification.object;
    
    if ([splitView isEqualTo:self.splitView]) {
        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        KFToolbarItem *bookmarksItem = appDelegate.toolBar.leftItems[2];
        if ([self.splitView isSubviewCollapsed:self.sideBarView] == NO) {
            _sideBarViewWidth = self.sideBarView.frame.size.width;
            bookmarksItem.state = NSOnState;
        } else {
            bookmarksItem.state = NSOffState;
        }
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if ([splitView isEqualTo:self.splitView]) {
        CGFloat max = self.splitView.frame.size.width/3;
        if (proposedMaximumPosition > max) {
            proposedMaximumPosition = max;
        }
        return proposedMaximumPosition;
    }
    return CGFLOAT_MAX;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if ([splitView isEqualTo:self.splitView]) {
        CGFloat min = self.splitView.frame.size.width/5;
        if (proposedMinimumPosition < min) {
            proposedMinimumPosition = min;
        }
        return proposedMinimumPosition;
    }
    return 0;
}

@end
