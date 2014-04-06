//
//  SolarSystemController.h
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey, Terri-Lynn Rimmer, Mark Gauci on 2014-03-23.
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
    GLfloat eyeYtemp;
    GLfloat eyeXtemp;
    GLfloat eyeZtemp;
    GLfloat viewingRadius;
    NSMutableArray *addedPlanets;
    
    BOOL rotate;
}

-(id)init;
-(void)initGeometry;
-(void)executeSolarSystem;
-(void)zoomOut;
-(void)zoomIn;
-(void)panSolarSystem:(CGPoint)moveDist isTouched:(BOOL)isTouched;
-(void)moveCameraPlanet:(CGPoint)moveDist;
-(void)pauseRotation;
-(void)resumeRotation;
-(NSMutableArray *)getPlanets;
-(void) selectedView:(int)index;

@end
