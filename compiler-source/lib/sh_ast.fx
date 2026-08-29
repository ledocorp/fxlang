// fx AST types (inspectable compiler source).
// Read-only snapshot for humans. Run the binary in bin/, do not rebuild from here.

module sh_ast;

using core;

enum Expr {
    Num(i32),
    StrLit(i32, i32),
    Ident(i32, i32),
    Add(i32, i32),
    Sub(i32, i32),
    Mul(i32, i32),
    Div(i32, i32),
    CmpLt(i32, i32),
    CmpNe(i32, i32),
    CmpEq(i32, i32),
    CmpGe(i32, i32),
    Deref(i32),
    Match(i32, i32, i32),
    CallExpr(i32, i32, i32, i32, i32, i32, i32),
    StructLit(i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32),
    TryExpr(i32),
    Index(i32, i32),
    SliceRange(i32, i32, i32),
    // FX-SH-NAT-7 - array literal `[a, b, …]` (count + up to 8 elem indices).
    ArrayLit(i32, i32, i32, i32, i32, i32, i32, i32, i32),
    // FX-SH-NAT-15b - `base with { f: v }` one-override foothold (base, fname_off, fname_ln, val).
    RecordUpdate(i32, i32, i32, i32),
}

enum Stmt {
    Let(i32, i32, i32, i32, i32),
    Return(i32),
    Assign(i32, i32, i32),
    AssignPtr(i32, i32, i32),
    If(i32, i32, i32, i32, i32),
    While(i32, i32, i32),
    Call(i32, i32, i32, i32),
    Break,
    Continue,
    Region(i32, i32, i32),
    // FX-SH-NAT-7 - `base[index] = value` (mut slice / array write).
    IndexAssign(i32, i32, i32),
}

enum TopItem {
    Module(i32, i32),
    Import(i32, i32),
    EnumDef(i32, i32, i32),
    StructDef(i32, i32, i32),
}

/// Discriminant helper - proves cross-module `Expr` use (SH-ERG-4.1 gate).
fn tag(e: Expr) -> i32 {
    return match e {
        Num(_) => 1,
        StrLit(_, _) => 2,
        Ident(_, _) => 3,
        Add(_, _) => 4,
        Sub(_, _) => 5,
        Mul(_, _) => 6,
        Div(_, _) => 7,
        CmpLt(_, _) => 8,
        CmpNe(_, _) => 9,
        CmpEq(_, _) => 10,
        CmpGe(_, _) => 11,
        Deref(_) => 12,
        Match(_, _, _) => 13,
        CallExpr(_, _, _, _, _, _, _) => 14,
        StructLit(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _) => 15,
        TryExpr(_) => 16,
        Index(_, _) => 17,
        SliceRange(_, _, _) => 18,
        ArrayLit(_, _, _, _, _, _, _, _, _) => 19,
        RecordUpdate(_, _, _, _) => 20,
    };
}
