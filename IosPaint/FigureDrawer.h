//
//  FigureDrawer.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/14/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FigureDrawer : UIView <NSCoding>

- (instancetype)initWithFrame:(CGRect)frame shape:(NSInteger)shape collor:(UIColor*)collor dekartSystem:(NSInteger)dekNum withInset:(NSNumber*)inset lineWidth:(NSInteger)width pointsOfLine:(NSArray *) LinePoints image:(UIImage *)image;


@property (nonatomic, assign) NSInteger dekNum;

@property (nonatomic, strong) NSArray *pointsOfLine;

@property (nonatomic, assign) NSInteger numOfSides;
@property (nonatomic, strong) UIImage* image;

//@property (nonatomic, assign) CGRect *settedFrame;
@end
