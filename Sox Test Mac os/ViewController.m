//
//  ViewController.m
//  Sox Test Mac os
//
//  Created by BugDev Studios on 07/10/2019.
//  Copyright © 2019 Conovo Inc. All rights reserved.
//

#import "ViewController.h"
#import "sox.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  NSString *sourcePath = [[NSBundle mainBundle ] pathForResource:@"temp" ofType:@"wav"];
  NSLog(@"path: %@", sourcePath );
  NSURL *sourceUrl = [NSURL fileURLWithPath:sourcePath];

  NSString *audioTempFolderPath = [self createDirectoryInDocumentsWithName:@"AudioTemp"];
  
  NSString *destUrlStr = [NSString stringWithFormat:@"%@%@%@", audioTempFolderPath, @"/", @"xtemp.wav"];
  
  NSURL *destUrl = [NSURL fileURLWithPath:destUrlStr];
  
  padTest(sourceUrl, destUrl);
  
//  silenceRemoveTest(sourceUrl, destUrl);
}



- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

BOOL silenceRemoveTest(NSURL *srcURL, NSURL *dstURL) {
  //remove the silence from the beginning and end of the audio in the Dir, Inner, and Actor Files
  @try {
    static sox_format_t *in, *out; /* input and output files */
    sox_effects_chain_t * effectsChain;
    sox_effect_t * soxEffect;
    char *args[10];
    /* All libSoX applications must start by initialising the SoX library */
    assert(sox_init() == SOX_SUCCESS);
    //NSLog(@"path.fileSystemRepresentation %s",startInputDirectoryPath.fileSystemRepresentation);
    assert(in = sox_open_read(srcURL.fileSystemRepresentation, NULL, NULL, NULL));
    
    /* Open the output file; we must specify the output signal characteristics.
     * Since we are using only simple effects, they are the same as the input
     * file characteristics */
    
    //NSLog(@"path.fileSystemRepresentation %s",modifiedAudio.fileSystemRepresentation);
    assert(out = sox_open_write(dstURL.fileSystemRepresentation, &in->signal, NULL, NULL, NULL, NULL));
    
    /* Create an effects chain; some effects need to know about the input
     * or output file encoding so we provide that information here */
    effectsChain = sox_create_effects_chain(&in->encoding, &out->encoding);
    
    //* The first effect in the effect chain must be something that can source
    //* samples; in this case, we use the built-in handler that inputs
    //* data from an audio file */
    
    soxEffect = sox_create_effect(sox_find_effect("input"));
    (void)(args[0] = (char *)in), assert(sox_effect_options(soxEffect, 1, args) == SOX_SUCCESS);
    /* This becomes the first `effect' in the chain */
    assert(sox_add_effect(effectsChain, soxEffect, &in->signal, &in->signal) == SOX_SUCCESS);
    
    char *options[10];
    
//    const char *sd = [durationToDetectSilence UTF8String];
//    const char *td = [thresholdCount UTF8String];
    
    options[0] = ("1");
    options[1] = ("0.3");
    options[2] = ("0.01%");
    for(int i = 0; i < 2; ++i) {
      // silence 1 0.3 0.1%
      soxEffect = sox_create_effect(sox_find_effect("silence"));
      
      if(sox_effect_options(soxEffect, 3, options) != SOX_SUCCESS) {
        //                             on_error("silence1 effect options error!");
        //                            printf("silence1 effect options error!");
        NSLog(@"silence1 effect options error!");
      }
      if(sox_add_effect(effectsChain, soxEffect, &in->signal, &in->signal) != SOX_SUCCESS) {
        NSLog(@"add effect error");
        //on_error("add effect error!");
      }
      free(soxEffect);
      
      // reverse
      soxEffect = sox_create_effect(sox_find_effect("reverse"));
      if(sox_effect_options(soxEffect, 0, NULL) != SOX_SUCCESS) {
        //on_error("silence1 effect options error!");
      }
      if(sox_add_effect(effectsChain, soxEffect, &in->signal, &in->signal) != SOX_SUCCESS) {
        //on_error("add effect error!");
      }
      free(soxEffect);
    }
    
    
    /* The last effect in the effect chain must be something that only consumes
     * samples; in this case, we use the built-in handler that outputs
     * data to an audio file */
    
    
    soxEffect = sox_create_effect(sox_find_effect("output"));
    (void)(args[0] = (char *)out), assert(sox_effect_options(soxEffect, 1, args) == SOX_SUCCESS);
    assert(sox_add_effect(effectsChain, soxEffect, &out->signal, &out->signal) == SOX_SUCCESS);
    
    /* Flow samples through the effects processing chain until EOF is reached */
    sox_flow_effects(effectsChain, NULL, NULL);
    
    /* All done; tidy up: */
    sox_delete_effects_chain(effectsChain);
    sox_close(out);
    sox_close(in);
    sox_quit();
    //  });
    
    
  }@catch (NSException *exception) {
    NSLog(@"Error Occure During Trimming: %@", [exception description]);
//    [self errorOccuredDuringFileTrim];
    //return NO;
  }
}

BOOL padTest(NSURL *srcURL, NSURL *dstURL) {
  @try {
    static sox_format_t *in, *out; /* input and output files */
    sox_effects_chain_t * effectsChain;
    sox_effect_t * soxEffect;
    char *args[10];
    /* All libSoX applications must start by initialising the SoX library */
    assert(sox_init() == SOX_SUCCESS);
    //NSLog(@"path.fileSystemRepresentation %s",startInputDirectoryPath.fileSystemRepresentation);
    assert(in = sox_open_read(srcURL.fileSystemRepresentation, NULL, NULL, NULL));
    
    /* Open the output file; we must specify the output signal characteristics.
     * Since we are using only simple effects, they are the same as the input
     * file characteristics */
    
    //NSLog(@"path.fileSystemRepresentation %s",modifiedAudio.fileSystemRepresentation);
    assert(out = sox_open_write(dstURL.fileSystemRepresentation, &in->signal, NULL, NULL, NULL, NULL));
    
    /* Create an effects chain; some effects need to know about the input
     * or output file encoding so we provide that information here */
    effectsChain = sox_create_effects_chain(&in->encoding, &out->encoding);
    
    //* The first effect in the effect chain must be something that can source
    //* samples; in this case, we use the built-in handler that inputs
    //* data from an audio file */
    
    soxEffect = sox_create_effect(sox_find_effect("input"));
    (void)(args[0] = (char *)in), assert(sox_effect_options(soxEffect, 1, args) == SOX_SUCCESS);
    /* This becomes the first `effect' in the chain */
    assert(sox_add_effect(effectsChain, soxEffect, &in->signal, &in->signal) == SOX_SUCCESS);
    
    char *options[10];
    
    options[0] = ("0");
    options[1] = ("1");
    
    soxEffect = sox_create_effect(sox_find_effect("pad"));
    
    if(sox_effect_options(soxEffect, 2, options) != SOX_SUCCESS) {
      //                             on_error("silence1 effect options error!");
      //                            printf("silence1 effect options error!");
      NSLog(@"pad effect options error!");
    }
    if(sox_add_effect(effectsChain, soxEffect, &in->signal, &in->signal) != SOX_SUCCESS) {
      NSLog(@"pad add effect error");
      //          on_error("add effect error!");
    }
    free(soxEffect);
    
    

    /* The last effect in the effect chain must be something that only consumes
     * samples; in this case, we use the built-in handler that outputs
     * data to an audio file */
    
    
    soxEffect = sox_create_effect(sox_find_effect("output"));
    (void)(args[0] = (char *)out), assert(sox_effect_options(soxEffect, 1, args) == SOX_SUCCESS);
    assert(sox_add_effect(effectsChain, soxEffect, &out->signal, &out->signal) == SOX_SUCCESS);
    
    /* Flow samples through the effects processing chain until EOF is reached */
    sox_flow_effects(effectsChain, NULL, NULL);
    
    /* All done; tidy up: */
    sox_delete_effects_chain(effectsChain);
    sox_close(out);
    sox_close(in);
    sox_quit();
    //  });
    
    
  }@catch (NSException *exception) {
    NSLog(@"Error Occure During Trimming: %@", [exception description]);
    //    [self errorOccuredDuringFileTrim];
    //return NO;
  }
  
}


- (NSString*)createDirectoryInDocumentsWithName: (NSString*) name{
  
  NSError *error;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
  
  NSFileManager* manager = [NSFileManager defaultManager];
  NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:name];
  
  if (![manager fileExistsAtPath:directoryPath]) {
    BOOL success = [manager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    if (success) {
      return directoryPath;
    }else {
      NSLog(@"%@",error.localizedDescription);
      return nil;
      
    }
  }else {
    NSArray *contents = [manager contentsOfDirectoryAtPath:directoryPath error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'wav'"];
    NSArray *filteredContents = [contents filteredArrayUsingPredicate:predicate];
    for (NSURL *fileURL in filteredContents) {
      if (fileURL != nil) {
        NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@",directoryPath,fileURL];
        NSURL *fileFullURL = [NSURL fileURLWithPath:fileFullPath];
        [manager removeItemAtURL:fileFullURL error:nil];
      }
    }
    
    return directoryPath;
  }
  
}


@end
