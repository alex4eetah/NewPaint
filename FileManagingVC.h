//
//  FileManagingVC.h
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 12/31/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelFiguresViewController.h"
#import "CanvasViewController.h"

@protocol ResizerProtocol;

@interface FileManagingVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, FileManagerGelegate>

@property (nonatomic, weak) id <PanelsDelegate> delegate;
@property (nonatomic, weak) id <ResizerProtocol> resizerDelegate;

@end

@protocol ResizerProtocol <NSObject>

- (void)resizeFileManagingContainerHeightTo:(CGFloat)height;
- (void)resizeColorContainerHeightTo:(CGFloat)height;

@end

