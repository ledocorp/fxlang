// std Queue facade over lib/ring_queue (bounded FIFO).
module queue;

import lib/ring_queue;

fn make(cap: i32 where > 0) -> Queue effects { alloc } {
    return ring_queue.make(cap);
}

fn size(q: Queue) -> i32 {
    return ring_queue.size(q);
}

fn is_empty(q: Queue) -> bool {
    return ring_queue.is_empty(q);
}

fn is_full(q: Queue) -> bool {
    return ring_queue.is_full(q);
}

fn enqueue(q: Queue, x: i32) -> Queue effects { alloc, mut } {
    return ring_queue.enqueue(q, x);
}

fn front(q: Queue) -> i32 effects { alloc } {
    return ring_queue.front(q);
}

fn dequeue(q: Queue) -> Queue {
    return ring_queue.dequeue(q);
}
