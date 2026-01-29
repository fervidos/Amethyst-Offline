#import "installer/FabricUtils.h"
#import "ModpackUtils.h"

@implementation ModpackUtils

+ (void)archive:(UZKArchive *)archive extractDirectory:(NSString *)dir toPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSMutableSet *createdDirectories = [NSMutableSet set];
    
    [archive performOnFilesInArchive:^(UZKFileInfo *fileInfo, BOOL *stop) {
        @autoreleasepool {
            if (![fileInfo.filename hasPrefix:dir] ||
                fileInfo.filename.length <= dir.length) {
                return;
            }
            NSString *fileName = [fileInfo.filename substringFromIndex:dir.length+1];
            NSString *destItemPath = [path stringByAppendingPathComponent:fileName];
            NSString *destDirPath = fileInfo.isDirectory ? destItemPath : destItemPath.stringByDeletingLastPathComponent;
            
            if (![createdDirectories containsObject:destDirPath]) {
                BOOL createdDir = [NSFileManager.defaultManager createDirectoryAtPath:destDirPath
                    withIntermediateDirectories:YES
                    attributes:nil error:error];
                if (!createdDir) {
                    *stop = YES;
                    return;
                }
                [createdDirectories addObject:destDirPath];
            }
            
            if (fileInfo.isDirectory) {
                return;
            }

            NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:destItemPath append:NO];
            [outputStream open];
            __block NSError *streamError = nil;

            BOOL extracted = [archive extractBufferedDataFromFile:fileInfo.filename error:error action:^(NSData *dataChunk, CGFloat percentDecompressed) {
                if (streamError) return;
                
                NSInteger written = [outputStream write:dataChunk.bytes maxLength:dataChunk.length];
                if (written == -1) {
                    streamError = outputStream.streamError;
                }
            }];
            
            [outputStream close];
            
            if (!extracted || streamError) {
                if (error && streamError) *error = streamError;
                *stop = YES;
            }
        }
    } error:error];
}

+ (NSDictionary *)infoForDependencies:(NSDictionary *)dependency {
    NSMutableDictionary *info = [NSMutableDictionary new];
    NSString *minecraftVersion = dependency[@"minecraft"];
    if (dependency[@"forge"]) {
        info[@"id"] = [NSString stringWithFormat:@"%@-forge-%@", minecraftVersion, dependency[@"forge"]];
    } else if (dependency[@"fabric-loader"]) {
        info[@"id"] = [NSString stringWithFormat:@"fabric-loader-%@-%@", dependency[@"fabric-loader"], minecraftVersion];
        info[@"json"] = [NSString stringWithFormat:(NSString *)FabricUtils.endpoints[@"Fabric"][@"json"], minecraftVersion, dependency[@"fabric-loader"]];
    } else if (dependency[@"quilt-loader"]) {
        info[@"id"] = [NSString stringWithFormat:@"quilt-loader-%@-%@", dependency[@"quilt-loader"], minecraftVersion];
        info[@"json"] = [NSString stringWithFormat:(NSString *)FabricUtils.endpoints[@"Quilt"][@"json"], minecraftVersion, dependency[@"quilt-loader"]];
    }
    return info;
}

@end
