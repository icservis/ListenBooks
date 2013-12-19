//
//  BookViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "BookViewController.h"
#import "BookPageController.h"

@interface BookViewController ()

@end

@implementation BookViewController {
    NSMutableArray* _bookPages;
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
    [self setupBookPageControllerContent];
    
}

- (void)setupBookPageControllerContent
{
    NSLog(@"setupBookPageControllerContent: %@", [self.pageController description]);
    
    NSAttributedString* string1 = [[NSAttributedString alloc] initWithString:@"page1"];
    NSTextView* textView1 = [[NSTextView alloc] initWithFrame:self.textView.frame];
    [textView1.textStorage setAttributedString:string1];
    
    NSAttributedString* string2 = [[NSAttributedString alloc] initWithString:@"page2"];
    NSTextView* textView2 = [[NSTextView alloc] initWithFrame:self.textView.frame];
    [textView2.textStorage setAttributedString:string2];
    
    NSAttributedString* string3 = [[NSAttributedString alloc] initWithString:@"page3"];
    NSTextView* textView3 = [[NSTextView alloc] initWithFrame:self.textView.frame];
    [textView3.textStorage setAttributedString:string3];
    
    NSAttributedString* string4 = [[NSAttributedString alloc] initWithString:@"page4"];
    NSTextView* textView4 = [[NSTextView alloc] initWithFrame:self.textView.frame];
    [textView4.textStorage setAttributedString:string4];
    
    NSAttributedString* string5 = [[NSAttributedString alloc] initWithString:@"page5"];
    NSTextView* textView5 = [[NSTextView alloc] initWithFrame:self.textView.frame];
    [textView5.textStorage setAttributedString:string5];

    
    _bookPages = [[NSMutableArray alloc] initWithObjects:textView1, textView2, textView3, textView4, textView5, nil];
    [self.pageController setArrangedObjects:_bookPages];
}

#pragma mark - BookPageController Delegate

- (void)pageController:(NSPageController *)pageController didTransitionToObject:(id)object {
    /* When image is changed, update info label's text */
    NSLog(@"PC did transitionToObject: %ld", [_pageController selectedIndex]);
}

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    /* Returns object's array index as identiefier */
    NSString *identifier = [[NSNumber numberWithInteger:[_bookPages indexOfObject:object]] stringValue];
    NSLog(@"identifier: %@", identifier);
    return identifier;
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier {
    
    NSViewController *vController = [NSViewController new];
    NSTextView *textView = [_bookPages objectAtIndex:[identifier integerValue]];
    NSLog(@"textView: %@", [textView description]);
    
    [vController setView:textView];
    return vController;
}

@end
