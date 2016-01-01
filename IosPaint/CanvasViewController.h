//
//  CanvasViewController.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelFiguresViewController.h"
#import "PanelColorViewController.h"
#import "LineDrawer.h"

@protocol FileManagerGelegate;

@interface CanvasViewController : UIViewController <PanelsDelegate>

@property (nonatomic, weak) id <FileManagerGelegate> delegate;

@end

@protocol FileManagerGelegate <NSObject>

- (void)showCurrentOperation:(NSString *)operation;

@end