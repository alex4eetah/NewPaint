//
//  FigureDrawer.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/14/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum shapeTypes
{
    circleShape,
    rectangleShape,
    linesShape,
    triangleShape,
    rightShape,
    imageShape,
    panLine
} ShapeType;


@interface FigureDrawer : UIView <NSCoding>

@property (nonatomic) ShapeType shape;
@property (nonatomic, strong) NSString *figureName;

- (instancetype)initWithFrame:(CGRect)frame shape:(NSInteger)shape color:(UIColor*)color dekartSystem:(NSInteger)dekNum withInset:(NSNumber*)inset lineWidth:(NSInteger)width pointsOfLine:(NSArray *) LinePoints image:(UIImage *)image;


@property (nonatomic, assign) NSInteger dekNum;

@property (nonatomic, strong) NSArray *pointsOfLine;

@property (nonatomic, assign) NSInteger numOfSides;
@property (nonatomic, strong) UIImage* image;

@property (nonatomic, assign) CGFloat rotationAngle;
@property (nonatomic, assign) CGRect frameBeforeRotation;
@property (nonatomic, assign) BOOL WasRorated;

- (void)highLightPenLine;
- (void)unHighLightPenLine;

//-(CGRect)originalFrame;
//-(CGPoint)centerOffset:(CGPoint)thePoint;
//-(CGPoint)pointRelativeToCenter:(CGPoint)thePoint;
//-(CGPoint)newPointInView:(CGPoint)thePoint;
//-(CGPoint)newTopLeft;

@end
