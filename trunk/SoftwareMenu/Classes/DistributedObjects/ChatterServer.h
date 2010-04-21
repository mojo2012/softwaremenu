#import <Foundation/Foundation.h>
#import "ChatterServing.h"

@interface ChatterServer : NSObject <ChatterServing> {
    NSMutableArray *clients;
    NSMutableArray *connectedSockets;
    NSManagedObjectContext *_moc;
}
- (void)sapphireEvent:(NSDictionary *)inputDict fromClient:(id<ChatterUsing>)client;
- (void)sapphireLoadMoc;
- (void)stopCurrentMovie;
- (void)remoteEvent:(NSDictionary *)dict fromClient:(id<ChatterUsing>)client;
@end
