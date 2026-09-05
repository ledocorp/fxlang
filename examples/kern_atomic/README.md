# kern_atomic

Atomic demo: \Atomic<i32>\ with explicit memory orders under \effects { atomic }\.

\\	ext
fx run examples/kern_atomic/main.fx --driver sh --emit-c
# or: fx run examples/kern_atomic/main.fx --fallback-emit-c
# expect exit 42
\
Atomic IR is out of scope this cut - prefer \--emit-c\ / \--fallback-emit-c\. Missing order is a type error (no silent defaults).
