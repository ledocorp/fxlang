// Bounded FIFO ring queue (public lib). Append-only Vec + head cursor.
// Capacity enforced with refinements; allocation via effects { alloc }.
module ring_queue;

struct Queue {
    data: Vec<i32>,
    head: i32 where >= 0,
    cap: i32 where > 0,
}

fn make(cap: i32 where > 0) -> Queue effects { alloc } {
    let d: Vec<i32> = vec_new(0);
    return Queue { data: d, head: 0, cap: cap };
}

fn size(q: Queue) -> i32 {
    return q.data.len - q.head;
}

fn is_empty(q: Queue) -> bool {
    return size(q) == 0;
}

fn is_full(q: Queue) -> bool {
    return size(q) >= q.cap;
}

fn enqueue(q: Queue, x: i32) -> Queue effects { alloc, mut } {
    if (is_full(q)) {
        return q;
    }
    return Queue { data: vec_push(q.data, x), head: q.head, cap: q.cap };
}

fn front(q: Queue) -> i32 effects { alloc } {
    return vec_get(q.data, q.head);
}

fn dequeue(q: Queue) -> Queue {
    if (is_empty(q)) {
        return q;
    }
    return Queue { data: q.data, head: q.head + 1, cap: q.cap };
}
