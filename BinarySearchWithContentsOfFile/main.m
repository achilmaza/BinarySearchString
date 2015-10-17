//---------------------------------------------------------------------------
//  main.m
//  BinarySearchWithContentsOfFile
//  Parses contents of txt file, sorts and then does binary search for string
//  using iteration and recursion
//
//  Created by Angie Chilmaza on 10/16/15.
//  Copyright © 2015 Angie Chilmaza. All rights reserved.
//
///---------------------------------------------------------------------------


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
            
            NSArray * lines = [contents componentsSeparatedByString:@"\n"];
            
            //Sort array
            NSArray * sortedArray = [lines sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            
            //remove duplicates
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:sortedArray];
            sortedArray = [orderedSet array];
            NSLog(@"sorted = %@ \n", sortedArray);
        
            
            //Time complexity -
            //O(log n) for both
            //But the recursive version takes twice as long to complete as the iterative
            //when measuring execution time
            
            int iterations = 0;
            NSDate *methodStart = [NSDate date];
            int index = binarySearchWithRecursion(@"Whoa! Mr. Trout!\"", sortedArray, 0, (int)[sortedArray count]-1, &iterations);
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            
            if(index >=0){
                NSLog(@"Recursive: Found string = %@ at index = %i iterations=%i\n", sortedArray[index], index, iterations);
                NSLog(@"total items = %lu \n",[sortedArray count]);
                NSLog(@"executionTime = %f", executionTime);
            }
            
            
            iterations = 0;
            methodStart = [NSDate date];
            index = binarySearch(@"Whoa! Mr. Trout!\"", sortedArray, &iterations);
            methodFinish = [NSDate date];
            executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            
            if(index >=0){
                 NSLog(@"Iterative: Found string = %@ at index = %i iterations=%i\n", sortedArray[index], index, iterations);
                 NSLog(@"total items = %lu \n",[sortedArray count]);
                 NSLog(@"executionTime = %f", executionTime);
            }
            
            
        }
        
    }
    return 0;
}


//binary search of a string
int binarySearchWithRecursion(NSString* comprString, NSArray* arr, int start, int end, int*iterations){
    
    int found  = -1;
    int mid    = (end + start) / 2;
    
    
    NSString * indexedString = arr[mid];
    NSComparisonResult comparisonResult = [indexedString caseInsensitiveCompare:comprString];
    
    if(comparisonResult == NSOrderedSame){
        found = mid;
    }
    //if start == end and match has yet not been found then string is not in the list
    //NSOrderedAscending - the left operand is smaller than the right operand.
    //----> GO RIGHT
    else if(comparisonResult == NSOrderedAscending && start < end){
        found = binarySearchWithRecursion(comprString, arr, mid+1, end, iterations);
    }
    //NSOrderedDescending - the left operand is greater than the right operand
    //<---- GO LEFT
    else if( comparisonResult == NSOrderedDescending && start < end){
        found = binarySearchWithRecursion(comprString, arr, start, mid-1, iterations);
    }
    
    
    (*iterations)++;
    return found;
    
}

int binarySearch(NSString* comprString, NSArray* arr, int*iterations){
    
    int mid   = 0;
    int start = 0;
    int end   = (int)[arr count] - 1;
    int found = -1;
    
    
    while (start <= end) {
        
        mid = (start + end)/2;
    
        NSString * indexedString = arr[mid];
        NSComparisonResult comparisonResult = [indexedString caseInsensitiveCompare:comprString];
        
        if(comparisonResult == NSOrderedSame){
            found = mid;
            break;
        }
        //if start == end and match has yet not been found then string is not in the list
        //NSOrderedAscending - the left operand is smaller than the right operand.
        else if(comparisonResult == NSOrderedAscending ){
            start = mid + 1;
        }
        //NSOrderedDescending - the left operand is greater than the right operand.
        else if( comparisonResult == NSOrderedDescending ){
           end = mid - 1;
        }
        (*iterations)++;
        
    }
    
    return found;
}