//
//  SolarSystemController.h
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Planet.h"

#define X_VALUE 0
#define Y_VALUE 1
#define Z_VALUE 2


@interface SolarSystemController : NSObject {
    
    Planet *planetSun;
    Planet *planetMercury;
    Planet *planetVenus;
	Planet *planetEarth;
    Planet *planetMoon;
    Planet *planetMars;
    
	GLfloat	eyePosition[3];
}

-(id)init;
-(void)initGeometry;
-(void)executeSolarSystem;
-(void)zoomOut;
-(void)zoomIn;
-(void)panSolarSystem:(CGPoint)moveDist;

@end
