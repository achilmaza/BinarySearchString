//
//  main.m
//  BinarySearchWithContentsOfFile
//
//  Created by Angie Chilmaza on 10/16/15.
//  Copyright © 2015 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

int binarySearchWithRecursion(NSString* comprString, NSArray* arr, int start, int end, int*iterations);
int binarySearch(NSString* comprString, NSArray* arr, int*iterations);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        NSFileHandle *inFile;
        NSMutableString* contents;
       
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"assorted-breakfast" ofType:@"txt"];
        inFile = [NSFileHandle fileHandleForReadingAtPath:filePath];
        if (inFile == nil) {
            NSLog (@"Open of %@ for reading failed\n", filePath);
        }
        else{
        
            contents = [NSMutableString stringWithContentsOfFile:filePath encoding: NSUTF8StringEncoding error: NULL];
        
            [inFile closeFile];
            
            NSArray * sortedArray = [contents componentsSeparatedByString:@"\n"];
            
            //sort array
            sortedArray = [sortedArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            NSLog(@"lines = %@ \n", sortedArray);
            
            //Performace should be O(log n)
            
            int iterations = 0;
            int index = binarySearchWithRecursion(@"Whoa! Mr. Trout!\"", sortedArray, 0, (int)[sortedArray count]-1, &iterations);
            
            int iterations2 = 0;
            int index2 = binarySearch(@"Whoa! Mr. Trout!\"", sortedArray, &iterations2);
            
            if(index >=0){
                NSLog(@"Recursive: Found string = %@ at index = %i iterations=%i\n", sortedArray[index], index, iterations);
                NSLog(@"total items = %lu \n",[sortedArray count]);
            }
            
            if(index2 >=0){
                 NSLog(@"Iterative: Found string = %@ at index = %i iterations=%i\n", sortedArray[index2], index2, iterations2);
            }
            
            
        }
        
    }
    return 0;
}

//binary search of a string

int binarySearchWithRecursion(NSString* comprString, NSArray* arr, int start, int end, int*iterations){
    
    int mid  = (end + start) / 2;
    int found  = -1;
    
    NSLog(@"binarySearch:: search string = %@\n", comprString);
    NSLog(@"binarySearch:: start = %d\n", start);
    NSLog(@"binarySearch:: end = %d\n", end);
    NSLog(@"binarySearch:: index = %d\n", mid);
    NSLog(@"----------------------------\n");
    
    //grab string
    NSString * indexedString = arr[mid];
    (*iterations)++;
    
    if([indexedString caseInsensitiveCompare:comprString] == NSOrderedSame){
        fprintf(stderr, " EQUAL \n");
        found = mid;
    }
    //if start == end and match has yet not been found then string is not in the list
    //NSOrderedAscending
    //The left operand is smaller than the right operand.
    else if( ([indexedString caseInsensitiveCompare:comprString] == NSOrderedAscending) && start<=end){
        fprintf(stderr, " ----> GO RIGHT \n");
        found = binarySearchWithRecursion(comprString, arr, mid+1, end, iterations);
    }
    
    //NSOrderedDescending
    //The left operand is greater than the right operand.
    else if( ([indexedString caseInsensitiveCompare:comprString] == NSOrderedDescending) && start<=end){
        fprintf(stderr, " <---- GO LEFT \n");
        found = binarySearchWithRecursion(comprString, arr, start, mid-1, iterations);
    }
    
    return found;
    
}

int binarySearch(NSString* comprString, NSArray* arr, int*iterations){
    
    int mid = -1;
    int min = 0;
    int max = (int)[arr count] - 1;
    
    int found = -1;
    
    while (min <= max) {
        
        mid = (min + max)/2;
    
        NSString * indexedString = arr[mid];
        
        if([indexedString caseInsensitiveCompare:comprString] == NSOrderedSame){
            found = mid;
            break;
        }
        //if start == end and match has yet not been found then string is not in the list
        //NSOrderedAscending
        //The left operand is smaller than the right operand.
        else if( ([indexedString caseInsensitiveCompare:comprString] == NSOrderedAscending)){
            min = mid + 1;
        }
        
        //NSOrderedDescending
        //The left operand is greater than the right operand.
        else if( ([indexedString caseInsensitiveCompare:comprString] == NSOrderedDescending)){
           max = mid - 1;
        }
        (*iterations)++;
        
    }
    
    return found;
}