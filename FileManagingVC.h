//
//  FileManagingVC.h
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 12/31/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelFiguresViewController.h"

@interface FileManagingVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <PanelsDelegate> delegate;

@end
