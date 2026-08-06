// FX-0.8-UX-3 — route desk confidence app (≥ ledger class, multi-module).
// stock Map helpers (IR multi-module + UX-3b region thread) + Vec + slip + files → 42.
// Dual-path: IR-default `fx run` and `--emit-c` (no silent fallback).
import std/io;
import std/string;
import std/map;
import std/vec;
import stock;

fn main() -> i32 effects { alloc, mut, io } {
    region r = arena(16384);

    let bins: Map<string, i32> = map.new();
    bins = stock.seed(bins);
    if (map.len(bins) != 3) {
        return 1;
    }
    if (stock.total(bins) != 30) {
        return 2;
    }

    bins = stock.receive(bins, "aisle", 6);
    bins = stock.receive(bins, "yard", 4);
    bins = stock.receive(bins, "hold", 7);
    if (map.len(bins) != 4) {
        return 3;
    }
    bins = stock.scrap_bin(bins, "hold");
    if (map.contains(bins, "hold")) {
        return 4;
    }
    if (stock.total(bins) != 40) {
        return 5;
    }

    let deltas: Vec<i32> = vec.new(0);
    deltas = vec.push(deltas, 5);
    deltas = vec.push(deltas, 0 - 2);
    deltas = vec.push(deltas, 3);
    if (vec.len(deltas) != 3) {
        return 6;
    }
    let i: i32 = 0;
    while (i < vec.len(deltas)) {
        bins = stock.receive(bins, "dock", deltas[i]);
        i = i + 1;
    }
    if (stock.qty_at(bins, "dock") != 16) {
        return 7;
    }
    if (stock.total(bins) != 46) {
        return 8;
    }

    bins = stock.receive(bins, "aisle", 0 - 4);
    if (stock.qty_at(bins, "aisle") != 14) {
        return 9;
    }
    if (stock.qty_at(bins, "yard") != 12) {
        return 10;
    }
    if (stock.total(bins) != 42) {
        return 11;
    }

    let sb = string.builder();
    sb = string.append(sb, "dock=");
    sb = string.append(sb, "16");
    sb = string.append(sb, ";aisle=");
    sb = string.append(sb, "14");
    sb = string.append(sb, ";yard=");
    sb = string.append(sb, "12");
    sb = string.append(sb, ";total=");
    sb = string.append(sb, "42");
    let slip = string.build(sb);
    if (string.len(slip) != 33) {
        return 12;
    }
    if (string.compare(slip, "dock=16;aisle=14;yard=12;total=42") == false) {
        return 13;
    }

    let path_a = "fx_route_desk_a.tmp";
    let path_b = "fx_route_desk_b.tmp";
    if (io.write_file(path_a, slip) != 0) {
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

    io.write_line("route_desk: ok");
    return 42;
}
