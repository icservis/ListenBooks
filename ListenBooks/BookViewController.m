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

@interface BookViewController ()

@property (strong) NSMutableArray *data;
@property (assign) id initialSelectedObject;

@end

@implementation BookViewController

@synthesize book = _book;

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
}

- (void)setupBookPageControllerContent:(NSURL*)epubURL
{
    DDLogVerbose(@"setupBookPageControllerContent");
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    self.libraryURL = [appDelegate applicationCacheDirectory];
    self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:self.libraryURL];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
}

- (Book*)book
{
    return _book;
}

- (void)setBook:(Book *)book
{
    if (book == nil) {
        [self resetPageView];
    } else if (![book isEqual:_book]) {
        [self resetPageView];
        [self setupBookPageControllerContent:book.fileUrl];
    }
    _book = book;
    
}

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    self.data = nil;
    self.initialSelectedObject = nil;
    self.titleField.stringValue = NSLocalizedString(@"No Selection", nil);
    [[self.pageView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[NSProgressIndicator class]]) {
            [subView removeFromSuperview];
        }
    }];
}

#pragma mark - KFEpubDelegate

- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    self.titleField.stringValue = NSLocalizedString(@"Opening Book…", nil);
    [self.progressIndicator startAnimation:nil];
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    self.contentModel = contentModel;
    DDLogVerbose(@"meta %@", contentModel.metaData);
    //DDLogVerbose(@"spine %@", [contentModel.spine description]);
    //DDLogVerbose(@"guide %@", [contentModel.guide description]);
    
    self.titleField.stringValue = [self.contentModel.metaData valueForKey:@"title"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background
        
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        [self.contentModel.spine enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if (self.contentModel == nil || idx >= [self.contentModel.spine count]) {
                *stop = YES;
            }
            NSString* media = self.contentModel.manifest[self.contentModel.spine[idx]][@"media"];
            
            if ([media isEqualToString:@"application/xhtml+xml"]) {
                
                NSString *contentFile = self.contentModel.manifest[self.contentModel.spine[idx]][@"href"];
                NSURL *contentURL = [self.epubController.epubContentBaseURL URLByAppendingPathComponent:contentFile];
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:contentURL documentAttributes:nil];
                if (attributedString != nil) {
                    [spinedData addObject:attributedString];
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.progressIndicator stopAnimation:nil];
            
            if ([spinedData count] > 0) {
                self.data = [[NSMutableArray alloc] initWithArray:spinedData];
                [self.pageController setArrangedObjects:self.data];
            } else {
                self.data = nil;
                [self resetPageView];
            }
        });
    });
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    DDLogError(@"epubController:didFailWithError: %@", error.description);
    [self.progressIndicator stopAnimation:nil];
    [self resetPageView];
}

#pragma mark - BookPageControllerDelegate

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
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    BookPageViewController* bookPageViewController = (BookPageViewController*)viewController;
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        NSScrollView* scrollView = (NSScrollView*)bookPageViewController.view;
        scrollView.magnification = 1;
    }
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController
{
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
}

@end
