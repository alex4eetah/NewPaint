//
//  LineDrawer.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/26/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDrawer : UIView

- (instancetype)initWithFrame:(CGRect)frame;
//@property (nonatomic, assign) NSInteger dekNum;
- (void)drawPanLinefrom:(NSMutableArray*)points;

@end
