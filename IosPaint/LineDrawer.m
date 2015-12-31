//
//  LineDrawer.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/26/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "LineDrawer.h"

@interface LineDrawer()

@property (nonatomic, strong) UIColor* collor;
@property (nonatomic, strong) NSNumber* inset;
@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) BOOL isit;

@end

@implementation LineDrawer


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor =  [UIColor whiteColor];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)drawPanLinefrom:(NSMutableArray*)points
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    NSValue *v = [points firstObject];
    CGPoint firstPint = [v CGPointValue];
    CGContextMoveToPoint(ctx, firstPint.x, firstPint.y);
    
    for (NSValue *v in points)
    {
        if (v != [points firstObject])
        {
            CGPoint point = [v CGPointValue];
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }
    
    
    CGContextStrokePath(ctx);
    //self.isit = YES;
}


@end
