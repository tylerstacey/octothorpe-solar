//
//  SolarSystemController.m
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import "SolarSystemController.h"
#import "SolarSystem.h"
#include "gluLookAt.h"

@implementation SolarSystemController
-(id)init {
    
	[self initGeometry];
	
	return self;
}

-(void)initGeometry {
    eyePosition[X_VALUE] = 0.0;
    eyePosition[Y_VALUE] = 0.0;
    eyePosition[Z_VALUE] = 10.0;
    viewingRadius = 10.0;
    eyeXtemp = 0;
    eyeYtemp = 1;
    eyeZtemp = 0;
    rotate = YES;
    planetSun = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:2.0] Squash:1.0 OrbitalPeriod:0.0 DistanceFromSun:[self auFromTheSun:0.0] TrackingPlanet:planetSun TextureFile:@"Sun.png"];
	[planetSun setPositionX:0.0 Y:0.0 Z:0.0];
    
    planetMercury = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.383] Squash:1.0 OrbitalPeriod:0.240 DistanceFromSun:[self auFromTheSun:0.387] TrackingPlanet:planetSun TextureFile:@"Mercury.png"];
    [planetMercury setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:0.387]];
    
    planetVenus = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.950] Squash:1.0 OrbitalPeriod:0.615 DistanceFromSun:[self auFromTheSun:0.723] TrackingPlanet:planetSun TextureFile:@"Venus.png"];
    [planetVenus setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:0.723]];
    
	planetEarth = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:1.0] Squash:1.0 OrbitalPeriod:1.0 DistanceFromSun:[self auFromTheSun:1.0] TrackingPlanet:planetSun TextureFile:@"Earth.png"];
	[planetEarth setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:1.0]];
    
    planetMoon = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.273] Squash:1.0 OrbitalPeriod:0.0748 DistanceFromSun:[self auFromTheSun:0.257] TrackingPlanet:planetEarth TextureFile:@"Moon.png"];
	[planetMoon setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:0.5]];
    
    planetMars = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.532] Squash:1.0 OrbitalPeriod:1.881 DistanceFromSun:[self auFromTheSun:1.524] TrackingPlanet:planetSun TextureFile:@"Mars.png"];
    [planetMars setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:1.524]];
    
    
    
}
-(void)executeSolarSystem {
    
	GLfloat white[] = {1.0,1.0,1.0,1.0};
	GLfloat black[] = {0.0,0.0,0.0,0.0};
	GLfloat sunPos[3] = {0.0,0.0,0.0};
    
	glPushMatrix();
    
    gluLookAt(eyePosition[X_VALUE], eyePosition[Y_VALUE], eyePosition[Z_VALUE], 0, 0, 0, eyeXtemp-eyePosition[X_VALUE],eyeYtemp-eyePosition[Y_VALUE],eyeZtemp-eyePosition[Z_VALUE]);
	glLightfv(SS_SUNLIGHT,GL_POSITION, sunPos);
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, white);
    
	glPushMatrix();
    if (rotate) {
        [planetMercury updatePosition:NO];
    } else {
        [planetMercury updatePosition:YES];
    }
	[planetMercury drawPlanet];
    glPopMatrix();

    glPushMatrix();
    if (rotate){
        [planetVenus updatePosition:NO];
    } else {
        [planetVenus updatePosition:YES];

    }
     [planetVenus drawPlanet];
    glPopMatrix();
    
    glPushMatrix();
    if (rotate){
        [planetMoon updatePosition:NO];
    } else {
        [planetMoon updatePosition:YES];
    }
    [planetMoon drawPlanet];
    glPopMatrix();
    
    glPushMatrix();
    if (rotate){
        [planetEarth updatePosition:NO];
    } else {
        [planetEarth updatePosition:YES];
    }
     [planetEarth drawPlanet];
    glPopMatrix();
    
    glPushMatrix();
    if (rotate){
        [planetMars updatePosition:NO];
    } else {
        [planetMars updatePosition:YES];
    }
     [planetMars drawPlanet];
    glPopMatrix();
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, white);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, black);
    
	[planetSun drawPlanet];
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, black);
	
	glPopMatrix();

}


-(GLfloat)earthWidths:(GLfloat)earthWidths {
    return 0.5 * earthWidths;
}

-(GLfloat)auFromTheSun:(GLfloat)au {
    return au * -4.0;
}

-(void)zoomOut {
    if (viewingRadius < 20){
        viewingRadius += 0.10;
        CGPoint point = CGPointMake(0, 0);
        [self panSolarSystem:point isTouched:NO];
    }
}

-(void)zoomIn {
    if (viewingRadius > 3){
        viewingRadius -= 0.10;
        CGPoint point = CGPointMake(0, 0);
        [self panSolarSystem:point isTouched:NO];
    }
}

-(void)panSolarSystem:(CGPoint)moveDist isTouched:(BOOL)isTouched{
	float radianX, radianY;
    if(isTouched == NO){
        radianX = 1*moveDist.x*90 * (3.14/180.0f);
        radianY = -moveDist.y*90 * (3.14/180.0f);
    } else {
        radianX = 1*moveDist.x/5 * (3.14/180.0f);
        radianY = -moveDist.y/5 * (3.14/180.0f);
    }
    eyePosition[X_VALUE] = (float)sin(radianY) * viewingRadius * (float)sin(radianX);
    eyePosition[Y_VALUE] = (float)cos(radianY) * viewingRadius;
    eyePosition[Z_VALUE] = (float)sin(radianY) * viewingRadius * (float)cos(radianX);
    
    eyeXtemp = (float)sin(radianY-1) * (float)sin(radianX) * viewingRadius;
    eyeYtemp = (float)cos(radianY-1) * viewingRadius;
    eyeZtemp = (float)sin(radianY-1) * (float)cos(radianX) * viewingRadius;
}
-(void)pauseRotation {
    rotate = NO;
}

-(void)resumeRotation {
    rotate = YES;
}
@end
