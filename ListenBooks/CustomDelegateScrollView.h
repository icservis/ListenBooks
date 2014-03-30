//
//  CustomMagnificationScrollView.h
//  ListenBooks
//
//  Created by Libor Kučera on 29.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CustomDelegateScrollView;

@protocol CustomDelegateScrollViewDelegate <NSObject>

@optional

- (void)customDelegateScrollView:(CustomDelegateScrollView*)scrollView didChangeMagnitication:(CGFloat)magnication;
- (void)customDelegateScrollView:(CustomDelegateScrollView*)scrollView didChangeRotation:(CGFloat)rotation;
- (void)customDelegateScrollViewDidChangeSmartMagnification:(CustomDelegateScrollView*)scrollView;
@end

@interface CustomDelegateScrollView : NSScrollView

@property (nonatomic, weak) id <CustomDelegateScrollViewDelegate> delegate;

@end
