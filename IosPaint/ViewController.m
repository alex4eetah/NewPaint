//
//  ViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/14/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "ViewController.h"
#import "FigureDrawer.h"

@interface ViewController ()

//@property (nonatomic) CGPoint start;
//@property (nonatomic) CGPoint stop;
//@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *centerAndRadiusRecognizer;
//@property (nonatomic) CGFloat lastScale;
//@property (nonatomic, strong) NSMutableArray* myViews;
//@property (nonatomic, strong) FigureDrawer* myView;
//@property (nonatomic, assign) NSInteger shape;
//@property (nonatomic, strong) UIColor* collor;
//@property (strong, nonatomic) IBOutlet UIView *MainMenuOutlet;
//@property (nonatomic, strong) UISegmentedControl* triangles;
//@property (strong, nonatomic) IBOutlet UIView *PoligonMenuOutlet;
//@property (strong, nonatomic) IBOutlet UITextField *NumberOfPoligonSidesTFOutlet;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *shapeMenuOutlet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//- (IBAction)MainMenu:(UISegmentedControl *)sender
//{
//    //self.shape = sender.selectedSegmentIndex;
//    
//    if (sender.selectedSegmentIndex == 0)
//    {
//        self.shapeMenuOutlet.hidden = NO;
//    }
//    else if (sender.selectedSegmentIndex == 1)
//    {
//        self.PoligonMenuOutlet.hidden = NO;
//    }
//    else
//    {
//        self.PoligonMenuOutlet.hidden = YES;
//        self.shapeMenuOutlet.hidden = YES;
//    }
//    

    
    
    /*if (sender.selectedSegmentIndex == 3)
    {
        NSArray *mySegments = [[NSArray alloc] initWithObjects: @"Right",
                               @"Blue", @"Green", @"Yellow", nil];
        
        //create an intialize our segmented control
        self.triangles = [[UISegmentedControl alloc] initWithItems:mySegments];
        
        //set the size and placement
        self.triangles.frame = CGRectMake(1, 1, 100, 100);

        
        
        //default the selection to second item
        [self.triangles setSelectedSegmentIndex:1];
        
        //attach target action for if the selection is changed by the user
        [self.triangles addTarget:self
                                    action:@selector(chooseTriangle:)
                          forControlEvents:UIControlEventValueChanged];
        
        //add the control to the view
        [self.view addSubview:self.triangles];
    }
}*/
//- (IBAction)ShapeMenu:(UISegmentedControl *)sender
//{
//    self.shape = sender.selectedSegmentIndex;
//    self.shapeMenuOutlet.hidden = YES;
//}
//- (IBAction)PoligonSubmit:(UIButton *)sender
//{
//    
//    self.myView.numOfSides = [self.NumberOfPoligonSidesTFOutlet.text integerValue];
//    self.myView.numOfSides = 6;
//    self.shape = 4;	
//    self.PoligonMenuOutlet.hidden = YES;
//}
//- (IBAction)numOfSides:(UITextField *)sender
//{
//    //self.myView.numOfSides = [sender.text integerValue];
//    
//}
//
//- (void)chooseTriangle:(UISegmentedControl *)sender
//{
//    
//}
//
//- (IBAction)ColorDidChanged:(UIButton *)sender
//{
//    self.collor = sender.backgroundColor;
//}

//- (IBAction)ChoseTheShapeButton:(UIButton *)sender
//{
//    FigureDrawer *myview = [[FigureDrawer alloc] initWithFrame:CGRectMake(100, 100, 150, 150)
//                                                         shape:sender.tag
//                                                   tapLocation:self.tappedLoaction];
//    self.lastView = myview
//    [self.view addSubview:myview];
//    
//   
//    myview.backgroundColor = [UIColor clearColor];
//    
//    [self.view addSubview:myview];
//    
//    //[self.view addSubview:[self.drawer initWithFrame:CGRectMake(100, 100, 150, 150)]];
//    
//    
//    
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch* touch = [[event allTouches] anyObject];
//    self.start = [touch locationInView:self.view];
//    
//    CGRect frame = CGRectMake(self.start.x,
//                              self.start.y,
//                              0, 0);
//    
//    self.myView = [[FigureDrawer alloc] initWithFrame:frame
//                                                shape:(int)self.shape
//                                               collor:self.collor
//                                        startLocation:self.start
//                                          endLocation:self.start];
//    
//    self.myView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.myView];
//    [self.myViews addObject:self.myView];
//}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = [[event allTouches] anyObject];
//    self.stop = [touch locationInView:self.view];
//    
//    CGFloat width = self.stop.x - self.start.x;
//    CGFloat height = self.stop.y - self.start.y;
//    
//    CGFloat x = width >= 0 ? self.start.x : self.start.x + width;
//    CGFloat y = height >= 0 ? self.start.y : self.start.y + height;
//    
//    CGRect frame;
//    if (self.shape == 4)
//        frame = CGRectMake(x, y, (fabs(height)+fabs(width))/2, (fabs(height)+fabs(width))/2);
//    else
//        frame = CGRectMake(x, y, fabs(width), fabs(height));
//    
//    
//    
//    if (width > 0 && height < 0)
//        self.myView.dekNum = 1;
//    else if (width < 0 && height < 0)
//        self.myView.dekNum = 2;
//    else if (width < 0 && height > 0)
//        self.myView.dekNum = 3;
//    else
//        self.myView.dekNum = 4;
//    
//    
//    self.myView.frame = frame;
//    [self.myView setNeedsDisplay];
//    [self.myViews removeObject:self.myViews.lastObject];
//    [self.myViews addObject:self.myView];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.myView = nil;
//}

//
//- (IBAction)handlePinchGestureRec:(UIPinchGestureRecognizer *)sender
//{
//    /*if ([sender state] == UIGestureRecognizerStateBegan) {
//        self.lastScale = 1.0;
//    }
//    
//    CGFloat scale = 1.0 - (self.lastScale - [sender scale]);
//    self.lastScale = [sender scale];
//    CGAffineTransform currentTransform = self.imageView.transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    [self.imageView setTransform:newTransform];
//    NSLog(@"center: %@", NSStringFromCGPoint(self.imageView.center));*/
//    self.tappedLoaction  = [sender locationInView:sender.view];
//    
//    
//    FigureDrawer *myview = [[FigureDrawer alloc] initWithFrame:CGRectMake(100, 100, 150, 150)
//                                                         shape:self.tag
//                                                   tapLocation:self.tappedLoaction];
//    [self.view addSubview:myview];
//    
//    
//    myview.backgroundColor = [UIColor clearColor];
//    
//    [self.view addSubview:myview];
//    
//}
/*- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{

    self.tappedLoaction  = [sender locationInView:self];

}*/

/*
#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    for (UIView *view in self.view.subviews)
    {
        if (CGRectContainsPoint(view.frame, point))
        {
            self.figure = view;
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    self.figure.center = point;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.figure = nil;
}
*/
@end