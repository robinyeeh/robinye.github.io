---
layout: post
title: "Rust求最大子数组的和"
date: 2018-05-27 06:36:58 +0080
comments: true
categories: "Rust"
---

###Rust求最大子数组的和



```
fn main() {
    let arr = [2,-1, 13, -5, -10, 9, 4, 7];

    let arr_len = arr.len();

    let mut max_sum = 0; //max sum
    let mut vec:Vec<i32> = vec![];

    for i in 0..arr_len{
//        println!("i: {}, iValue : {}.",i, arr[i]);

        let mut current_sum = 0;
        for j in i..arr_len{
            println!("i: {}, j: {}, jValue : {}.", i,j, arr[j]);

            current_sum += arr[j];
            println!("Max sum is : {}, current sum : {}", max_sum, current_sum);

            if current_sum > max_sum {
                max_sum = current_sum;
                vec.push(arr[j]);

                println!("Got greater max sum : {}", max_sum);
            }
        }
    }

    println!("Max sum of successive sub array is : {}.", max_sum);

    let mut arr_str = String::new();
    arr_str += "[";
    for i in &vec {
        arr_str = format!("{0},{1}", &arr_str, i);
//        arr_str += &a_str;
    }
    arr_str += "]";
    println!("Max sub array is : {}.", arr_str);
}
```





 