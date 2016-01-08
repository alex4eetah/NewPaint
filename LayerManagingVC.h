//
//  LayerManagingVC.h
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 1/4/16.
//  Copyright © 2016 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "headerWithProtocols.h"


@interface LayerManagingVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <ResizerProtocol> resizerDelegate;
@property (nonatomic, weak) id <LayerManagerGelegate> layerDelegate;

- (void)getPreparedForShowing;

@end
