//
//  headerWithProtocols.h
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 1/4/16.
//  Copyright © 2016 Olexander_Chechetkin. All rights reserved.
//

#ifndef headerWithProtocols_h
#define headerWithProtocols_h


#endif
#import "FigureDrawer.h"

@protocol ResizerProtocol <NSObject>

- (void)resizeFileManagingContainerHeightTo:(CGFloat)height;
- (void)resizeColorContainerHeightTo:(CGFloat)height;
- (void)moveLayerManagingContainerLeftOnWidth:(CGFloat)width;

@end

@protocol PanelsDelegate <NSObject>

- (void)didSelectWidth:(NSInteger)width;
- (void)didSelectColor:(UIColor *)color;
- (void)didSelectShape:(NSInteger)shape;
- (void)didSelectImage:(UIImage *)image;
- (void)didSelectOperation:(NSInteger)operation;
- (void)writeFigureToFile:(NSString *)pathComponent;
- (void)saveFigureToGallery;
- (void)loadDataFromFile:(NSString *)pathComponent;
- (void)Undo;
- (void)allClear;
- (void)setCurrentOperation:(NSInteger)value;
- (void)setNumOfSides:(NSInteger)numOfSides;

@end

@protocol FileManagerGelegate <NSObject>

- (void)showCurrentOperation:(NSString *)operation;
- (void)showCurrentShape:(NSString *)shape;
- (void)HighLightCurrentOperation;

@end

@protocol LayerManagerGelegate <NSObject>

- (void)prepareLayerPanel;
- (void)changeLayerName:(NSInteger)layer toName:(NSString *)name;
- (NSArray *)takeArrayOfSubviews;
- (void)highLightLayerAtIndex:(NSInteger)index;
- (void)unHighlightLayerAtIndex:(NSInteger)index;
- (void)putUpCurrentLayerAtIndex:(NSInteger)index;
- (void)putDownCurrentLayerAtIndex:(NSInteger)index;
- (void)deleteLayerAtIndex:(NSInteger)index;

@end