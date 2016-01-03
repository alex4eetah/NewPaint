//
//  PanelColorViewController.h
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelFiguresViewController.h"
#import "FileManagingVC.h"

#pragma mark - DelegateProtocol

@interface PanelColorViewController : UIViewController  <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <PanelsDelegate> delegate;
@property (nonatomic, weak) id <ResizerProtocol> resizerDelegate;


@end

