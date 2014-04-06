//
//  ViewController.h
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey, Terri-Lynn Rimmer, Mark Gauci on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "SolarSystem.h"
#import "SolarSystemController.h"

#define kFILTERMODELOWPASS  1
#define kMOTIONUPDATEINTERVAL 15.0

@interface ViewController : GLKViewController {
    SolarSystemController *solarSystem;
};
-(void)getIndex:(NSInteger*)index;
-(void)viewDidLoad;
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
-(void)setClipping;
-(void)initLighting;

@end
