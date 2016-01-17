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

@property (nonatomic, assign) NSInteger dekNum;
//dekart system number

@property (nonatomic, strong) NSArray *pointsOfLine;
//points for drawing pen line

@property (nonatomic, assign) NSInteger numOfSides;
//for poligon, witch numOfSides is known only in run-time

@property (nonatomic, strong) UIImage* image;

@property (nonatomic, assign) CGFloat rotationAngle;
@property (nonatomic, assign) CGRect frameBeforeRotation;
@property (nonatomic, assign) BOOL WasRorated;
//Dicription:
//this properties are used for correct redrawing of digures, after saving to file (if cgaffineRotation was applied).

- (instancetype)initWithFrame:(CGRect)frame shape:(NSInteger)shape color:(UIColor*)color dekartSystem:(NSInteger)dekNum withInset:(NSNumber*)inset lineWidth:(NSInteger)width pointsOfLine:(NSArray *) LinePoints image:(UIImage *)image;

- (void)highLightPenLine;
- (void)unHighLightPenLine;
//layer managment

@end
