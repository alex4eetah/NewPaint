//
//  LineDrawer.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/26/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "LineDrawer.h"

@interface LineDrawer()

@property (nonatomic, strong) UIColor* lineCollor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) NSString* type;

@end

@implementation LineDrawer


- (instancetype)initWithFrame:(CGRect)frame point:(CGPoint)point typeOfLine:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.lineCollor = [UIColor greenColor];
        self.lineWidth = 1.0;
        self.backgroundColor =  [UIColor clearColor];
        self.point = point;
        self.type = type;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if ([self.type isEqualToString:@"horizontal"])
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, self.lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(ctx, [self.lineCollor CGColor]);
        
        CGContextMoveToPoint(ctx, self.frame.origin.x ,self.point.y);
        CGContextAddLineToPoint(ctx, self.frame.size.width ,self.point.y);
        CGContextStrokePath(ctx);
    }
    else if ([self.type isEqualToString:@"vertical"])
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, self.lineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(ctx, [self.lineCollor CGColor]);
        
        CGContextMoveToPoint(ctx, self.point.x, self.frame.origin.y);
        CGContextAddLineToPoint(ctx, self.point.x, self.frame.size.height);
        CGContextStrokePath(ctx);
    }
}


@end
