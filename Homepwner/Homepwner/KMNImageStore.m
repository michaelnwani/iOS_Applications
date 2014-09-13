//
//  KMNImageStore.m
//  Homepwner
//
//  Created by Michael Nwani on 9/8/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNImageStore.h"

@interface KMNImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation KMNImageStore

+(instancetype)sharedStore
{
    static KMNImageStore *sharedStore;
    
//    if (!sharedStore)
//    {
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    static dispatch_once_t onceToken; //This is to protect the singleton (that there should only be one instance of KMNImageStore in the case of a multi-threaded application
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

//No one should call init
-(instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[KMNImageStore sharedStore]"];
    
    return nil;
}

//Secret designated initializer
-(instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    //Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    //Turn image into JPEG data; NSData provides an easy way to create, modify, and delete buffers of memory for whatever objects we want.
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    //Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
//    return self.dictionary[key]; OLD IMPLEMENTATION
    
    //If possible, get it from the dictionary
    UIImage *result = self.dictionary[key];
    
    if (!result)
    {
        NSString *imagePath = [self imagePathForKey:key];
        
        //Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        //If we found an image on the file system, place it into the cache
        if (result)
        {
            self.dictionary[key] = result;
        }
        else
        {
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    
    return result;
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key]; //Saving every image as a standalone file in the Document directory. Otherwise how will our code know how to load back the right image?
}

-(void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}
@end
