// FX-0.8-DEMO-1 — mini ledger smoke app (~160 LOC).
// Map books + Vec batch + StrBuilder receipt + file lifecycle → exit 42.
// Dual-path: IR-default `fx run` and `--emit-c` (no emit-C fallback on IR run).
//
// Story: open cash/stock, post a short trading day, fold a zero-delta batch,
// write a receipt, rename it, delete it, return 42.
import std/io;
import std/string;
import std/vec;
import std/map;

fn main() -> i32 effects { alloc, mut, io } {
    region r = arena(16384);

    // --- open books + post a short day ---
    let books: Map<string, i32> = map.new();
    books = map.add_i32(books, "cash", 50);
    books = map.add_i32(books, "stock", 20);
    // Sell inventory: stock -8, cash +20 → cash=70, stock=12.
    books = map.add_i32(books, "stock", 0 - 8);
    books = map.add_i32(books, "cash", 20);
    // Expense: cash -48 → cash=22, stock=12 (total 34).
    books = map.add_i32(books, "cash", 0 - 48);
    // Temporary fee account then remove (map.remove smoke).
    books = map.add_i32(books, "fees", 5);
    if (map.len(books) != 3) {
        return 1;
    }
    books = map.remove(books, "fees");
    if (map.contains(books, "fees")) {
        return 2;
    }
    // Adjust to demo target: +8 cash → cash=30, stock=12, total=42.
    books = map.add_i32(books, "cash", 8);

    if (map.len(books) != 2) {
        return 3;
    }
    if (map.contains(books, "cash") == false) {
        return 4;
    }
    if (map.contains(books, "stock") == false) {
        return 5;
    }

    // --- dense walk: locate cash/stock balances ---
    let cash: i32 = 0;
    let stock: i32 = 0;
    let i: i32 = 0;
    while (i < map.len(books)) {
        let k = map.nth_key(books, i);
        let v = map.nth_value(books, i);
        if (string.compare(k, "cash")) {
            cash = v;
        }
        if (string.compare(k, "stock")) {
            stock = v;
        }
        i = i + 1;
    }
    if (cash != 30) {
        return 6;
    }
    if (stock != 12) {
        return 7;
    }

    let sum: i32 = 0;
    i = 0;
    while (i < map.len(books)) {
        sum = sum + map.nth_value(books, i);
        i = i + 1;
    }
    if (sum != 42) {
        return 8;
    }

    // --- zero-delta Vec batch (preserve total; exercises push + index) ---
    let deltas: Vec<i32> = vec.new(0);
    deltas = vec.push(deltas, 0);
    deltas = vec.push(deltas, 0);
    deltas = vec.push(deltas, 0);
    if (vec.len(deltas) != 3) {
        return 9;
    }
    i = 0;
    while (i < vec.len(deltas)) {
        books = map.add_i32(books, "cash", deltas[i]);
        i = i + 1;
    }
    sum = 0;
    i = 0;
    while (i < map.len(books)) {
        sum = sum + map.nth_value(books, i);
        i = i + 1;
    }
    if (sum != 42) {
        return 10;
    }

    // --- StrBuilder receipt ---
    let sb = string.builder();
    sb = string.append(sb, "cash=");
    sb = string.append(sb, "30");
    sb = string.append(sb, ";stock=");
    sb = string.append(sb, "12");
    sb = string.append(sb, ";total=");
    sb = string.append(sb, "42");
    let text = string.build(sb);
    if (string.len(text) != 25) {
        return 11;
    }
    if (string.compare(text, "cash=30;stock=12;total=42") == false) {
        return 12;
    }

    // --- file lifecycle: write → exists → append → rename → delete ---
    let path_a = "fx_mini_ledger_a.tmp";
    let path_b = "fx_mini_ledger_b.tmp";
    if (io.write_file(path_a, text) != 0) {
        return 20;
    }
    if (io.file_exists(path_a) == false) {
        return 21;
    }
    if (io.append_file(path_a, "") != 0) {
        return 22;
    }
    if (io.rename_file(path_a, path_b) != 0) {
        return 23;
    }
    if (io.file_exists(path_a)) {
        return 24;
    }
    if (io.file_exists(path_b) == false) {
        return 25;
    }
    if (io.delete_file(path_b) != 0) {
        return 26;
    }
    if (io.file_exists(path_b)) {
        return 27;
    }

    io.write_line("mini_ledger: ok");
    return 42;
}
