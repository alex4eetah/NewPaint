//
//  FigureDrawer.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/14/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "FigureDrawer.h"

@interface UIColor (randomizator)

+ (UIColor *)generateRandomColorWithoutColor:(UIColor *)color;

@end

@implementation UIColor (randomizator)

+ (UIColor *)generateRandomColorWithoutColor:(UIColor *)color
{
    UIColor *thisColor = [self generateRandome];
    
    if (![thisColor isEqual:color])
        return thisColor;
    else
        return [self generateRandomColorWithoutColor:color];
}

+ (UIColor *)generateRandome
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end









@interface FigureDrawer()

@property (nonatomic, strong) UIColor* collor;
@property (nonatomic, strong) NSNumber* inset;
@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, strong) UIColor *highlitedColor;

@end

@implementation FigureDrawer

- (instancetype)initWithFrame:(CGRect)frame shape:(NSInteger)shape collor:(UIColor*)collor dekartSystem:(NSInteger)dekNum withInset:(NSNumber*)inset lineWidth:(NSInteger)width pointsOfLine:(NSArray *)LinePoints image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
       // self.currentTransform =
        self.shape = (int)shape;
        self.collor = collor;
        self.inset = inset;
        self.lineWidth = width;
        self.pointsOfLine = LinePoints;
        self.image = image;
        self.figureName = [NSString stringWithFormat:@"Figure %p",self];
        self.WasRorated = NO;
        //self.frameBeforeTransform = self.frame;
       // self.fillThePath = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    switch (self.shape)
    {
        case linesShape:
            [self drawLines:rect];
            break;
        case rectangleShape:
            [self drawRectangle:rect];
            break;
        case circleShape:
            [self drawCircle:rect];
            break;
        case triangleShape:
            [self drawTriangle:rect];
            break;
        case rightShape:
            [self drawRight:rect];
            break;
        case imageShape:
            [self addImage:rect];
            break;
        case panLine:
            if (self.highlitedColor)
                [self drawPanLine:self.pointsOfLine andColor:self.highlitedColor];
            else
                [self drawPanLine:self.pointsOfLine andColor:nil];
            break;
        default:
            break;
    }
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: [NSNumber numberWithFloat:self.rotationAngle] forKey:@"rotationAngle"];
    [aCoder encodeObject: [NSValue valueWithCGRect:self.frameBeforeTransform] forKey:@"frameBeforeTransform"];
    [aCoder encodeObject: [NSValue valueWithCGRect:self.frame] forKey:@"frame"];
    
    [aCoder encodeObject: self.figureName forKey:@"figureName"];
    [aCoder encodeObject: [NSNumber numberWithLong: (int)self.shape] forKey:@"shape"];
    [aCoder encodeObject: self.collor forKey:@"collor"];
    [aCoder encodeObject: self.inset forKey:@"inset"];
    [aCoder encodeObject: [NSNumber numberWithLong: self.lineWidth] forKey:@"lineWidth"];
    [aCoder encodeObject: [NSNumber numberWithLong: self.dekNum] forKey:@"dekNum"];
    [aCoder encodeObject: [NSNumber numberWithLong: self.numOfSides] forKey:@"numOfSides"];
    [aCoder encodeObject: self.image forKey:@"image"];
    [aCoder encodeObject: self.pointsOfLine forKey:@"pointsOfLine"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.rotationAngle = [[aDecoder decodeObjectForKey:@"rotationAngle"] floatValue];
        if (self.rotationAngle)
        {
            self.frameBeforeTransform = [[aDecoder decodeObjectForKey:@"frameBeforeTransform"] CGRectValue];
            self.frame = self.frameBeforeTransform;
            CGAffineTransform transform = CGAffineTransformMakeRotation(self.rotationAngle);
            self.transform = transform;
        }
        else
        {
            self.frame = [[aDecoder decodeObjectForKey:@"frame"] CGRectValue];
        }
        
        
        
        self.figureName = [aDecoder decodeObjectForKey:@"figureName"];
        self.shape = (int)[[aDecoder decodeObjectForKey:@"shape"] longValue];
        self.collor = [aDecoder decodeObjectForKey:@"collor"];
        self.inset = [aDecoder decodeObjectForKey:@"inset"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.lineWidth = (int)[[aDecoder decodeObjectForKey:@"lineWidth"] longValue];
        self.dekNum = (int)[[aDecoder decodeObjectForKey:@"dekNum"] longValue];
        self.numOfSides = (int)[[aDecoder decodeObjectForKey:@"numOfSides"] longValue];
        self.pointsOfLine = [aDecoder decodeObjectForKey:@"pointsOfLine"];
    }
    return self;
}

- (void)drawLines:(CGRect)rect
{
    CGRect newRect = CGRectInset(rect, 0, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGPoint endPoint = CGPointMake(newRect.size.width, newRect.size.height);
    CGContextSetStrokeColorWithColor(ctx, [self.collor CGColor]);
    
    
    if (self.dekNum == 1 || self.dekNum == 3)
    {
        CGContextMoveToPoint(ctx, newRect.origin.x, endPoint.y);
        CGContextAddLineToPoint(ctx, endPoint.x, newRect.origin.y);
    }
    else
    {
        CGContextMoveToPoint(ctx, newRect.origin.x, newRect.origin.y);
        CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    }
    CGContextStrokePath(ctx);
    
    
}

- (void) drawPanLine:(NSArray *)points andColor:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (color)
        [color setStroke];
    else
        [self.collor setStroke];
    path.lineWidth = self.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    NSValue *value = [points firstObject];
    CGPoint firstPoint = [value CGPointValue];
    [path moveToPoint:firstPoint];

    if (points.count > 2)
    {
        [path addLineToPoint:[self getMidPointBetweenPointA:firstPoint
                                                       andB:[[points objectAtIndex:1] CGPointValue]]];
        for (int i = 1; i < points.count-1; i++)
        {
            CGPoint midpoint = [self getMidPointBetweenPointA:[[points objectAtIndex:i] CGPointValue]
                                                         andB:[[points objectAtIndex:i+1] CGPointValue]];
            [path addQuadCurveToPoint:midpoint
                         controlPoint:[[points objectAtIndex:i] CGPointValue]];
        }
        [path addLineToPoint:[[points lastObject] CGPointValue]];
    }
    else if (points.count == 2)
    {
        [path addLineToPoint:[self getMidPointBetweenPointA:firstPoint andB:[[points objectAtIndex:1] CGPointValue]]];
    }
    else
    {
        [path addLineToPoint:firstPoint];
    }
    [path stroke];
}

- (CGPoint) getMidPointBetweenPointA:(CGPoint)a andB:(CGPoint)b
{
    return CGPointMake((a.x + b.x)/2, (a.y + b.y)/2);
}

- (void) drawRectangle:(CGRect)rect
{
 
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [self.collor CGColor]);
    
    
    CGContextAddRect(ctx, CGRectInset
                     (CGRectMake(0, 0, rect.size.width, rect.size.height),
                      self.inset.doubleValue, self.inset.doubleValue));
    
    
    CGContextStrokePath(ctx);
    
}

- (void)drawCircle:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [self.collor CGColor]);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddEllipseInRect(ctx, CGRectInset(rect, self.inset.doubleValue, self.inset.doubleValue));
    CGContextStrokePath(ctx);
}

- (void)drawTriangle:(CGRect)rect
{
    CGRect insetRect = CGRectInset(rect, self.inset.doubleValue/2, self.inset.doubleValue/2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [self.collor CGColor]);
    
    CGPoint STPoint;
    CGPoint LBPoint;
    CGPoint RBPoint;
    
    if (self.dekNum >= 1 && self.dekNum <= 4)
    {
        if (self.dekNum == 1)
        {
            STPoint = CGPointMake(0, insetRect.size.height);
            LBPoint = CGPointMake(insetRect.size.width, insetRect.size.height/2);
            RBPoint = CGPointMake(insetRect.size.width/2, 0);
        }
        else if (self.dekNum == 2)
        {
            STPoint = CGPointMake(insetRect.size.width, insetRect.size.height);
            LBPoint = CGPointMake(insetRect.size.width/2, 0);
            RBPoint = CGPointMake(0, insetRect.size.height/2);
        }
        else if (self.dekNum == 3)
        {
            STPoint = CGPointMake(insetRect.size.width, 0);
            LBPoint = CGPointMake(0, insetRect.size.height/2);
            RBPoint = CGPointMake(insetRect.size.width/2, insetRect.size.height);
        }
        else 
        {
            STPoint = CGPointMake(0, 0);
            LBPoint = CGPointMake(insetRect.size.width/2, insetRect.size.height);
            RBPoint = CGPointMake(insetRect.size.width, insetRect.size.height/2);
        }
        
        CGContextMoveToPoint(ctx, STPoint.x, STPoint.y);
        CGContextAddLineToPoint(ctx, LBPoint.x, LBPoint.y);
        CGContextAddLineToPoint(ctx, RBPoint.x, RBPoint.y);
        CGContextAddLineToPoint(ctx, STPoint.x, STPoint.y);
        
        CGContextStrokePath(ctx);
    }
}

- (void)drawRight:(CGRect)rect
{
    CGFloat inset = [self.inset floatValue];
    CGRect insetRect = CGRectMake(rect.origin.x + inset, rect.origin.y + inset, rect.size.width - inset, rect.size.height - inset);
    
    CGFloat side = (insetRect.size.width/2);
    CGPoint newZeroCoordinate = CGPointMake(insetRect.size.width/2, insetRect.size.height/2);

    CGFloat alpha;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();///&&&&&&&&&&&&&&??????????????
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [self.collor CGColor]);
    
    for (int i = 0; i <= self.numOfSides; i++)
    {
        alpha = 2*M_PI*i/self.numOfSides; /// about NULL here
        CGPoint p = CGPointMake(side*cos(alpha)+newZeroCoordinate.x, side*sin(alpha)+newZeroCoordinate.y);
        if(i == 0)
            CGContextMoveToPoint(ctx, p.x, p.y);
        else
            CGContextAddLineToPoint(ctx, p.x, p.y);
    }

    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

- (void)addImage:(CGRect)rect
{
    [self.image drawInRect:CGRectMake(0.0, 0.0, rect.size.width, rect.size.height)];
}

- (void)highLightPenLine
{
    self.highlitedColor = [[UIColor alloc] init];
    self.highlitedColor = [UIColor generateRandomColorWithoutColor:self.collor];
    [self setNeedsDisplay];
}

- (void)unHighLightPenLine
{
    self.highlitedColor = nil;
    [self setNeedsDisplay];
}

@end
