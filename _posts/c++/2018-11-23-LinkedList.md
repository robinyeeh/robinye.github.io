---
layout: post
title: "Max Sum of Sub Array"
date: 2018-11-23 21:21:18 +0080
comments: true
categories: "c++"
---

### LinkedList

LinkedList.hpp

```
//
// Created by robin-laptop on 2018/11/23.
//

#ifndef LINKEDLIST_LINKEDLIST_HPP
#define LINKEDLIST_LINKEDLIST_HPP

typedef struct Node {
    int data;
    Node *pre;
    Node *next;
} Node;

class LinkedList {
private:
    Node *head;
    Node *last;

    int length;

public:
    LinkedList();

    Node* createNode();

    bool push(int data);

    int pop();

    int at(int index);

    bool insert(int index, int data);

    void list();

    void reverse_list();

    int size();
};


#endif //LINKEDLIST_LINKEDLIST_HPP

```

LinkedList.cpp

```
//
// Created by robin-laptop on 2018/11/23.
//

#include <LinkedList.hpp>
#include <malloc.h>
#include <iostream>


LinkedList::LinkedList() {
    head = createNode();
    last = head;
    length = 0;
}

Node *LinkedList::createNode() {
    Node *node = (Node*) malloc(sizeof(Node));
    return node;
}

bool LinkedList::push(int data) {
    Node *node = createNode();
    if (! node) {
        return false;
    }

    node -> data = data;
    node -> pre = last;
    last -> next = node;

    last = node;
    length ++;

    return true;
}

int LinkedList::pop() {
    int data = 0;

    Node *node = head -> next;
    while (node ->next) {
        node = node -> next;
    }

    data = node -> data;
    last = node -> pre;
    last ->next = node -> next;
    length --;

    free(node);
    node = NULL;

    return data;
}

int LinkedList::at(int index) {
    if (index < 0 || index > length-1) {
        return 0;
    }

    Node *p = head;
    for (int i = 0; i < index + 1; ++i) {
        p = p->next;
    }

    int data = p->data;
    return data;
}

bool LinkedList::insert(int index, int data) {
    if (index < 0 || index > length-1) {
        return false;
    }

    Node *p = head;
    for (int i = 0; i < index + 1; ++i) {
        p = p -> next;
    }

    Node *node = createNode();
    if (! node) {
        return false;
    }
    node -> data = data;

    node->pre = p->pre;
    p->pre = node;
    node->next = p;
    node->pre->next = node;

    length ++;

    return true;
}

void LinkedList::list() {
    for (int i = 0; i < length; ++i) {
        int data = at(i);

        printf("index : %d, data : %d\n", i, data);
    }
}

void LinkedList::reverse_list() {
    for (int i = length -1; i >=0 ; --i) {
        int data = at(i);

        printf("index : %d, data : %d\n", i, data);
    }
}

int LinkedList::size() {
    return length;
}
```

main.cpp

```
#include <iostream>
#include <LinkedList.hpp>

int main() {

    LinkedList* linkedList = new LinkedList;

    linkedList->push(10);
    linkedList->push(11);
    linkedList->push(12);
    linkedList->push(13);
    linkedList->push(14);
    linkedList->push(15);

    printf("size : %d\n", linkedList->size());

//    printf("pop val : %d\n", linkedList->pop());

    printf("list index : %d\n", linkedList->at(0));
    printf("list index : %d\n", linkedList->at(6));

    linkedList->insert(3, 20);
    printf("list index : %d\n", linkedList->at(5));

    linkedList->list();

    printf("\n");
    linkedList->reverse_list();

    return 0;
}
```