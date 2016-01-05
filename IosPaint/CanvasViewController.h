//
//  CanvasViewController.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
/*#import "PanelFiguresViewController.h"
#import "PanelColorViewController.h"
#import "LineDrawer.h"*/
#import "headerWithProtocols.h"


@interface CanvasViewController : UIViewController <PanelsDelegate>

@property (nonatomic, weak) id <FileManagerGelegate> delegate;

- (void)setCurrentOperationWithNSNumber:(NSNumber*)number;
- (void)highLightGivenLayerAtIndex:(NSInteger)index;
- (void)unHighlighGiventLayerAtIndex:(NSInteger)index;


@end

