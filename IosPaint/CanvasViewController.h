//
//  CanvasViewController.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "headerWithProtocols.h"

typedef enum operationsType
{
    drawing,
    movement,
    scaleing,
    rotating,
    chosingArea
} OperationType;

@interface CanvasViewController : UIViewController <PanelsDelegate>

@property (nonatomic, weak) id <FileManagerGelegate> delegate;
@property (nonatomic, strong) NSMutableArray *myViews;

- (void)changeFigureName:(NSInteger)layer toName:(NSString *)name;
- (void)highLightGivenLayerAtIndex:(NSInteger)index;
- (void)unHighlighGiventLayerAtIndex:(NSInteger)index;
- (void)putUpCurrentLayerAtIndex:(NSInteger)index;
- (void)putDownCurrentLayerAtIndex:(NSInteger)index;
- (void)deleteLayerAtIndex:(NSInteger)index;

@end

