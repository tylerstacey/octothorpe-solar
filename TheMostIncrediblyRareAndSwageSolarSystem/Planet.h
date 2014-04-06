//
//  Planet.h
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey, Terri-Lynn Rimmer, Mark Gauci on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>

@interface Planet : NSObject {
	
@private
    
	GLfloat	*planetVertexData;
	GLubyte	*planetColorData;
	GLfloat	*planetNormalData;
    GLfloat *planetTexCoordsData;
	GLint planetStacks;
    GLint planetSlices;
	GLfloat	planetRadius;
	GLfloat	planetSquash;
	GLfloat	planetAngle;
    GLfloat planetOrbitalPeroid;
    GLfloat planetDistanceFromSun;
	GLfloat	planetPos[3];
    Planet *trackingPlanet;
    
    GLKTextureInfo  *planetTextureInfo;
}

-(bool)drawPlanet;
-(void)updatePosition:(BOOL)isPaused;
-(void)setPositionX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z;
-(void)getPositionX:(GLfloat *)x Y:(GLfloat *)y Z:(GLfloat *)z;
-(id)initWithStacks:(GLint)stacks Slices:(GLint)slices Radius:(GLfloat)radius Squash:(GLfloat)squash OrbitalPeriod:(GLfloat)orbitalPeriod DistanceFromSun:(GLfloat)distanceFromSun TrackingPlanet:(Planet *)planet TextureFile:(NSString *)textureFile;
-(GLKTextureInfo *)loadTexture:(NSString *)filename;
@end
