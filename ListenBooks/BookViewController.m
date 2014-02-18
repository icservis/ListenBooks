//
//  BookViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BookViewController.h"
#import "BookPageViewController.h"
#import "TabBarControllerProtocol.h"
#import "NSTextView+Extensions.h"
#import "Book.h"
#import "Bookmark.h"
#import "Page.h"
#import "ProgressWindowController.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import "FontControl.h"
#import "VoiceControl.h"
#import "ThemeControl.h"
#import "BookBookmarksView.h"
#import "BookPageView.h"

@interface BookViewController ()

@property (strong) id initialSelectedObject;
@property (strong) IBOutlet NSPageController *pageController;
@property (strong, nonatomic) IBOutlet FontControl* fontControl;
@property (strong, nonatomic) IBOutlet VoiceControl* voiceControl;
@property (strong, nonatomic) IBOutlet ThemeControl *themeControl;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *sideBarView;
@property (weak) IBOutlet BookBookmarksView *bookBookmarksView;

#pragma mark - Internal Outlets

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;
@property (weak) IBOutlet NSTextField *pageLabel;
@property (weak) IBOutlet BookPageView *pageView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

#pragma mark - Font Panel

@property (weak) IBOutlet NSButton *fontPanelButton;
- (IBAction)fontPanelButtonClicked:(id)sender;
@property (weak) IBOutlet NSPanel *fontPanel;
@property (weak) IBOutlet NSSlider *fontSizeSlider;
- (IBAction)fontSizeSliderChange:(id)sender;
@property (weak) IBOutlet NSPopUpButton *fontNamePopup;
- (IBAction)fontNamePopupChanged:(id)sender;

#pragma mark - Themes Panel

@property (weak) IBOutlet NSButton *themePanelButton;
- (IBAction)themePanelButtonClicked:(id)sender;
@property (strong) IBOutlet NSPanel *themePanel;
@property (weak) IBOutlet NSSegmentedControl *themeSegmentedControl;
- (IBAction)themeSegmentedControlDidChange:(id)sender;

#pragma mark - Voice Panel

@property (weak) IBOutlet NSButton *voicePanelButton;
- (IBAction)voicePanelButtonClicked:(id)sender;
@property (strong) IBOutlet NSPanel *voicePanel;
@property (weak) IBOutlet NSSlider *voiceSpeedSlider;
- (IBAction)voiceSpeedSliderChanged:(id)sender;
@property (weak) IBOutlet NSPopUpButton *voiceNamePopup;
- (IBAction)voiceNamePopupChanged:(id)sender;

@end

@implementation BookViewController {
    CGFloat _toolBarFrameHeight;
    CGFloat _sideBarViewWidth;
}

@synthesize book = _book;
@synthesize bookmark = _bookmark;

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
    
    AppDelegate* appDelegate = [self appDelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
    
    _toolBarFrameHeight = self.toolBarView.frame.size.height;
    _sideBarViewWidth = self.sideBarView.frame.size.width;
    
    [self.bookBookmarksView setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]]];
    [self.pageView setDelegate:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.initialSelectedObject = nil;
}

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

#pragma mark - Notifications

- (void)contextDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"v: %@", notification.object);
    [self.bookBookmarksView reloadData];
}

- (IBAction)fontSizeSliderChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FontSizeDidChangeNotificaton object:sender];
}

- (IBAction)fontNamePopupChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FontNameDidChangeNotificaton object:sender];
}

- (IBAction)themeSegmentedControlDidChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeDidChangeNotificaton object:sender];
}

- (IBAction)voiceSpeedSliderChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VoiceSpeedDidChangeNotificaton object:sender];
}

- (IBAction)voiceNamePopupChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VoiceNameDidChangeNotificaton object:sender];
}

#pragma mark - Setters

- (void)setBook:(Book *)book
{
    DDLogVerbose(@"self: %@", self);
    if (![book isEqual:_book]) {
        _bookmark = nil;
        [self resetPageView];
        if ([book.pages count] > 0) {
            [self loadPageContent:book];
        }
    }
    _book = book;
    [self.bookBookmarksView reloadData];
}

- (Book*)book
{
    return _book;
}

- (void)setBookmark:(Bookmark *)bookmark
{
    if ([self.pageController.arrangedObjects count] > 0) {
        [self loadBookmark:bookmark];
    }
    _bookmark = bookmark;
}

- (Bookmark*)bookmark
{
    return _bookmark;
}

- (FontControl*)fontControl
{
    if (_fontControl == nil) {
        _fontControl = [[FontControl alloc] init];
    }
    return _fontControl;
}

- (VoiceControl*)voiceControl
{
    if (_voiceControl == nil) {
        _voiceControl = [[VoiceControl alloc] init];
    }
    return _voiceControl;
}

- (ThemeControl*)themeControl
{
    if (_themeControl == nil) {
        _themeControl = [[ThemeControl alloc] init];
    }
    return _themeControl;
}

#pragma mark - Actions

- (IBAction)fontPanelButtonClicked:(id)sender
{
    if ([self.fontPanel isVisible]) {
        [self.fontPanel close];
    } else {
        [self.fontPanel makeKeyAndOrderFront:sender];
    }
}

- (IBAction)themePanelButtonClicked:(id)sender
{
    if ([self.themePanel isVisible]) {
        [self.themePanel close];
    } else {
        [self.themePanel makeKeyAndOrderFront:sender];
    }
}

- (IBAction)voicePanelButtonClicked:(id)sender
{
    if ([self.voicePanel isVisible]) {
        [self.voicePanel close];
    } else {
        [self.voicePanel makeKeyAndOrderFront:sender];
    }
}

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    
    self.initialSelectedObject = nil;
    self.pageController.arrangedObjects = nil;
    [[self.pageView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[NSProgressIndicator class]]) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)loadPageContent:(Book*)book
{
    DDLogInfo(@"loadBookPageControllerContent");
    
    [self.progressIndicator startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        NSArray* pages = [[book.pages allObjects] sortedArrayUsingComparator:^NSComparisonResult(Page* obj1, Page* obj2) {
            NSInteger sortIndex1 = [obj1.sortIndex integerValue];
            NSInteger sortIndex2 = [obj2.sortIndex integerValue];
            
            if (sortIndex1 < sortIndex2) {
                return NSOrderedAscending;
            } else if (sortIndex1 > sortIndex2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        [pages enumerateObjectsUsingBlock:^(Page* page, NSUInteger idx, BOOL *stop) {
            [spinedData addObject:page.data];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.pageController setArrangedObjects:[[NSMutableArray alloc] initWithArray:spinedData]];
            if (self.bookmark != nil) {
                [self loadBookmark:self.bookmark];
            }
            [self.progressIndicator stopAnimation:nil];
        });
    });
}

- (void)loadBookmark:(Bookmark*)bookmark
{
    NSInteger page = [bookmark.page integerValue];
    self.pageController.selectedIndex = page;
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
    return (self.toolBarView.frame.size.height > 0) ? YES:NO;
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

- (IBAction)add:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"New Bookmark", nil)];
    
    Bookmark* bookmark = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Bookmark class]) inManagedObjectContext:self.managedObjectContext];
    bookmark.book = self.book;
    bookmark.created = [NSDate date];
    bookmark.page = [NSNumber numberWithInteger:[self.pageController selectedIndex]];
    
    [[[self appDelegate] undoManager] endUndoGrouping];
}

- (IBAction)edit:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
}

- (IBAction)remove:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"Delete Bookmark", nil)];
    
    [[self.bookBookmarksView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        Bookmark* bookmark = [self tableView:self.bookBookmarksView objectValueForTableColumn:nil row:idx];
        [self.managedObjectContext deleteObject:bookmark];
    }];
    
    [[[self appDelegate] undoManager] endUndoGrouping];
}

#pragma mark - PageControllerDelegate

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object
{
    NSString *identifier = @"BookPage";
    return identifier;
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier
{    
    BookPageViewController* bookPageViewController = [[BookPageViewController alloc] initWithNibName:@"BookPageViewController" bundle:nil];
    
    return bookPageViewController;
}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object
{
    // viewControllers may be reused... make sure to reset important stuff like the current magnification factor.
    
    self.pageLabel.stringValue = [NSString stringWithFormat:@"%@: %li / %li", NSLocalizedString(@"Page", nil), (long)pageController.selectedIndex+1, [self.pageController.arrangedObjects count]];
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    BookPageViewController* bookPageViewController = (BookPageViewController*)viewController;
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        NSScrollView* scrollView = (NSScrollView*)bookPageViewController.view;
        scrollView.magnification = 1;
        
        [bookPageViewController.textView changeFontSize:[self.book.fontSizeDelta doubleValue]];
        [bookPageViewController.textView setFontFamily:self.book.fontName];
        NSDictionary* selectedTheme = [[self.themeControl arrangedObjects] objectAtIndex:[self.book.themeIndex integerValue]];
        [bookPageViewController.textView setBackgroundColor:[selectedTheme valueForKey:@"BackgroundColor"]];
        [bookPageViewController.textView setForegroundColor:[selectedTheme valueForKey:@"ForegroundColor"]];
    }
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController
{
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
        AppDelegate* appDelegate = [self appDelegate];
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

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.book.bookmarks count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSArray* bookmarks = [[self.book.bookmarks allObjects] sortedArrayUsingDescriptors:[tableView sortDescriptors]];
    return bookmarks[row];
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [tableView reloadData];
}

- (void)open
{
    DDLogVerbose(@"open: %li", (long)[self.bookBookmarksView selectedRow]);
}

@end
