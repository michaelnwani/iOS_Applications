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
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
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
    }
    
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

-(UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
