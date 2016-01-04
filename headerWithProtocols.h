//
//  headerWithProtocols.h
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 1/4/16.
//  Copyright © 2016 Olexander_Chechetkin. All rights reserved.
//

#ifndef headerWithProtocols_h
#define headerWithProtocols_h


#endif /* headerWithProtocols_h */

@protocol ResizerProtocol <NSObject>

- (void)resizeFileManagingContainerHeightTo:(CGFloat)height;
- (void)resizeColorContainerHeightTo:(CGFloat)height;

@end

@protocol PanelsDelegate <NSObject>

- (void)didSelectWidth:(NSInteger)width;
- (void)didSelectColor:(UIColor *)color;
- (void)didSelectShape:(NSInteger)shape;
- (void)didSelectImage:(UIImage *)image;
- (void)didSelectOperation:(NSInteger)operation;
- (void)writeFigureToFile:(NSString *)pathComponent;
- (void)saveFigureToGallery;
- (void)loadDataFromFile:(NSString *)docFilePath;
- (void)Undo;
- (void)allClear;

@end

@protocol FileManagerGelegate <NSObject>

- (void)showCurrentOperation:(NSString *)operation;

@end