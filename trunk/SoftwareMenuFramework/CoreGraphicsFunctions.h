/*
 *  CoreGraphicsFunctions.h
 *  SoftwareMenuFramework
 *
 *  Created by Thomas Cool on 5/9/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */
#ifndef CGFunctions
#define CGFunctions
static float CGMidX(CGRect rect)
{
    return (rect.origin.x+rect.size.width/2);
}

static float CGMidY(CGRect rect)
{
    return (rect.origin.y+rect.size.height/2);
}
#endif