---
layout: post
title: "Max Sum of Sub Array"
date: 2018-11-23 20:33:13 +0080
comments: true
categories: "c++"
---

### Max Sum of Sub Array

```
#include <iostream>

int max_sub_arr(const int arr[], int size){
    int max_so_far =0,  max_ending_here = 0;
    int start = 0, end = 0, s = 0;
    for (int i = 0; i < size; ++i) {
        max_ending_here = max_ending_here + arr[i];

        if (max_ending_here < 0) {
            max_ending_here = 0;
            s += 1;
        }

        if (max_ending_here > max_so_far) {
            max_so_far = max_ending_here;
            start = s;
            end = i;
        }

        printf("start : %d, end : %d, s : %d\n", start, end, s);
        printf("max ending : %d, max so far : %d, index : %d\n", max_ending_here, max_so_far, i);
    }

    return max_so_far;
}

int main() {
    int arr[] = {1, 5, -1, 10, 23, -1, -20, -5 -15, 10, 7, 12, -22, 15, 10, 9, -13, 17};
    int size = sizeof(arr)/sizeof(int);

    int max = max_sub_arr(arr, size);

    printf("max : %d", max);
}
```