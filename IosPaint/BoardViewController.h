//
//  BoardViewController.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "headerWithProtocols.h"


@interface BoardViewController : UIViewController  <ResizerProtocol, LayerManagerGelegate>

@end
