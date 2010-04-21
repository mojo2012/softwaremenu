//
//  CALHeader.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/5/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CALayer (protectedAccess)
- (void)setFrame:(NSRect)fp8;


@end


/*@interface CALayer : NSObject <NSCoding>
+ (id)CA_attributes;
+ (id)defaultValueForKey:(id)fp8;
+ (id)layer;
+ (BOOL)automaticallyNotifiesObserversForKey:(id)fp8;
+ (id)defaultActionForKey:(id)fp8;
- (id)retain;
- (void)release;
- (unsigned int)retainCount;
- (id)init;
- (id)initWithBounds:(NSRect)fp8;
- (id)initWithLayer:(id)fp8;
- (void)dealloc;
- (id)debugDescription;
- (id)valueForKey:(id)fp8;
- (id)valueForUndefinedKey:(id)fp8;
- (void)setValue:(id)fp8 forKey:(id)fp12;
- (void)setValue:(id)fp8 forUndefinedKey:(id)fp12;
- (id)valueForKeyPath:(id)fp8;
- (void)setValue:(id)fp8 forKeyPath:(id)fp12;
- (id)initWithCoder:(id)fp8;
- (void)encodeWithCoder:(id)fp8;
- (BOOL)shouldArchiveValueForKey:(id)fp8;
- (NSRect)bounds;
- (void)setBounds:(NSRect)fp8;
- (NSPoint)position;
- (void)setPosition:(NSPoint)fp8;
- (struct CGAffineTransform)affineTransform;
- (void)setAffineTransform:(struct CGAffineTransform)fp8;
- (BOOL)isHidden;
- (BOOL)hidden;
- (void)setHidden:(BOOL)fp8;
- (NSRect)frame;
- (void)setFrame:(NSRect)fp8;
- (NSPoint)convertPoint:(NSPoint)fp8 fromLayer:(id)fp16;
- (NSPoint)convertPoint:(NSPoint)fp8 toLayer:(id)fp16;
- (NSRect)convertRect:(NSRect)fp8 fromLayer:(id)fp24;
- (NSRect)convertRect:(NSRect)fp8 toLayer:(id)fp24;
- (double)convertTime:(double)fp8 fromLayer:(id)fp16;
- (double)convertTime:(double)fp8 toLayer:(id)fp16;
- (id)hitTest:(NSPoint)fp8;
- (BOOL)containsPoint:(NSPoint)fp8;
- (id)contents;
- (void)setContents:(id)fp8;
- (BOOL)isOpaque;
- (BOOL)opaque;
- (void)setOpaque:(BOOL)fp8;
- (BOOL)clearsContext;
- (void)setClearsContext:(BOOL)fp8;
- (BOOL)needsDisplayOnBoundsChange;
- (void)setNeedsDisplayOnBoundsChange:(BOOL)fp8;
- (unsigned int)edgeAntialiasingMask;
- (void)setEdgeAntialiasingMask:(unsigned int)fp8;
- (id)contentsGravity;
- (void)setContentsGravity:(id)fp8;
- (BOOL)masksToBounds;
- (void)setMasksToBounds:(BOOL)fp8;
- (id)sublayers;
- (void)setSublayers:(id)fp8;
- (id)superlayer;
- (id)mask;
- (void)setMask:(id)fp8;
- (id)delegate;
- (void)setDelegate:(id)fp8;
- (void)removeFromSuperlayer;
- (void)insertSublayer:(id)fp8 atIndex:(unsigned int)fp12;
- (void)addSublayer:(id)fp8;
- (void)insertSublayer:(id)fp8 below:(id)fp12;
- (void)insertSublayer:(id)fp8 above:(id)fp12;
- (void)replaceSublayer:(id)fp8 with:(id)fp12;
- (id)actionForKey:(id)fp8;
- (void)addAnimation:(id)fp8 forKey:(id)fp12;
- (void)removeAllAnimations;
- (void)removeAnimationForKey:(id)fp8;
- (id)animationForKey:(id)fp8;
- (BOOL)_scheduleAnimationTimer;
- (void)_cancelAnimationTimer;
- (id)presentationLayer;
- (id)modelLayer;
- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(NSRect)fp8;
- (void)renderInContext:(struct CGContext *)fp8;
//- (void)display;
- (void)_display;
- (void)drawInContext:(struct CGContext *)fp8;
- (void)setNeedsLayout;
- (NSSize)preferredFrameSize;
- (void)layoutIfNeeded;
- (void)layoutSublayers;
- (unsigned int)autoresizingMask;
- (void)setAutoresizingMask:(unsigned int)fp8;
- (void)resizeSublayersWithOldSize:(NSSize)fp8;
- (void)resizeWithOldSuperlayerSize:(NSSize)fp8;
- (BOOL)doubleSided;

@end

@interface CALayer (CALayerPrivate)
+ (unsigned long)copyPropertyList:(const struct _CAPropertyDescription **)fp8;
+ (id)properties;
- (BOOL)sortsSublayers;
- (void)setSortsSublayers:(BOOL)fp8;
- (void)invalidateContents;
- (void)setContentsChanged;
- (void *)regionBeingDrawn;
- (BOOL)needsDisplay;
- (void)displayIfNeeded;
- (BOOL)_shouldSmoothFonts;
- (BOOL)needsLayout;
- (id)hitTest:(NSPoint)fp8 fromLayer:(id)fp16;
- (BOOL)isDescendantOf:(id)fp8;
- (id)ancestorSharedWithLayer:(id)fp8;
- (id)sublayerEnumerator;
- (NSSize)size;
- (id)layerBeingDrawn;
- (BOOL)respondsToSelector:(SEL)fp8;
- (id)methodSignatureForSelector:(SEL)fp8;
- (void)forwardInvocation:(id)fp8;
- (id)attributesForKey:(id)fp8;
- (id)attributesForKeyPath:(id)fp8;
- (struct _CARenderLayer *)_copyRenderLayer:(struct _CATransaction *)fp8 flags:(unsigned int *)fp12;
- (_Bool)_renderLayerDefinesProperty:(unsigned int)fp8;
- (_Bool)_renderLayerPropertyAffectsGeometry:(unsigned int)fp8;
- (void)layerDidBecomeVisible:(BOOL)fp8;
- (double)beginTime;
- (double)timeOffset;
- (double)duration;
- (float)speed;
- (float)repeatCount;
- (double)repeatDuration;
- (BOOL)autoreverses;
- (id)fillMode;
- (NSPoint)anchorPoint;
- (float)zPosition;
- (struct CATransform3D)transform;
- (struct CATransform3D)sublayerTransform;
- (struct CGAffineTransform)contentsTransform;
- (NSRect)contentsRect;
- (id)magnificationFilter;
- (id)minificationFilter;
- (float)minificationFilterBias;
- (float)opacity;
- (struct CGColor *)backgroundColor;
- (id)name;
- (id)filters;
- (id)backgroundFilters;
- (id)compositingFilter;
- (struct CGColor *)borderColor;
- (float)borderWidth;
- (float)cornerRadius;
- (float)shadowOpacity;
- (struct CGColor *)shadowColor;
- (NSSize)shadowOffset;
- (float)shadowRadius;
- (id)layoutManager;
- (float)nearClippingDepth;
- (void)setNearClippingDepth:(float)fp8;
- (BOOL)floating;
@end*/

