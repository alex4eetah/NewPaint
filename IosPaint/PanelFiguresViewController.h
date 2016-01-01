//
//  PanelFiguresViewController.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanelsDelegate;

@interface PanelFiguresViewController : UIViewController

@property (nonatomic, weak) id <PanelsDelegate> delegate;

@end

@protocol PanelsDelegate <NSObject>

- (void)didSelectWidth:(NSInteger)width AndOpacity:(CGFloat)opacity;
- (void)didSelectColor:(UIColor *)color;
- (void)didSelectShape:(NSInteger)shape;
- (void)didSelectImage:(UIImage *)image;
- (void)didSelectOperation:(NSInteger)operation;
- (void)writeFigureToFile:(NSString *)pathComponent;
- (void)loadDataFromFile:(NSString *)docFilePath;
- (void)resizeFileManagingContainerHeightTo:(CGFloat)height;

@end