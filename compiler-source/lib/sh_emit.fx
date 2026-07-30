// fx emit helpers (inspectable compiler source).
// Emit/lowering and related verification helpers.
// Read-only snapshot for humans. Run the binary in bin/, do not rebuild from here.

module sh_emit;

using core;

import std/string;
import sh_lexer;
import sh_parse;

fn str_contains(hay: string, needle: string) -> i32 {
    let hlen: i32 = string.len(hay);
    let nlen: i32 = string.len(needle);
    if (nlen > hlen) {
        return 0;
    }
    let i: i32 = 0;
    while (i <= hlen - nlen) {
        if (sh_lexer.slice_eq(hay, i, nlen, needle) == 1) {
            return 1;
        }
        i = i + 1;
    }
    return 0;
}

fn fixture_ok_main_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_main()?;
    if (str_contains(c_src, "#include <stdint.h>") != 1) {
        return Ok(74);
    }
    if (str_contains(c_src, "int32_t fx_ok_main_main") != 1) {
        return Ok(75);
    }
    if (str_contains(c_src, "return 0") != 1) {
        return Ok(76);
    }
    if (str_contains(c_src, "ok_main body_len=1") != 1) {
        return Ok(77);
    }
    return Ok(42);
}

fn fixture_ok_add_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_add()?;
    if (str_contains(c_src, "int32_t fx_ok_add_add(int32_t a, int32_t b)") != 1) {
        return Ok(80);
    }
    if (str_contains(c_src, "return (a + b)") != 1) {
        return Ok(81);
    }
    if (str_contains(c_src, "fx_ok_add_add(1, 2)") != 1) {
        return Ok(82);
    }
    if (str_contains(c_src, "return x") != 1) {
        return Ok(83);
    }
    if (str_contains(c_src, "ok_add body_len=1") != 1) {
        return Ok(84);
    }
    if (str_contains(c_src, "ok_add_main body_len=2") != 1) {
        return Ok(85);
    }
    if (str_contains(c_src, "int32_t x = fx_ok_add_add(1, 2)") != 1) {
        return Ok(86);
    }
    if (str_contains(c_src, "int32_t fx_ok_add_main(void)") != 1) {
        return Ok(87);
    }
    return Ok(42);
}

// SH-C-28 - bootstrap-emitted lex-family C markers (gates 392-397).
fn fixture_bootstrap_lexer_smoke_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_lexer_smoke()?;
    if (str_contains(c_src, "/* SH-C-28 - bootstrap lex-family smoke */") != 1) {
        return Ok(392);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_lexer_smoke_slice_eq(int32_t a, int32_t b)") != 1) {
        return Ok(393);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_lexer_smoke_lex(int32_t a, int32_t b)") != 1) {
        return Ok(394);
    }
    if (str_contains(c_src, "fx_bootstrap_lexer_smoke_lex(40, 2)") != 1) {
        return Ok(395);
    }
    if (str_contains(c_src, "bootstrap_lexer_smoke_lex body_len=1") != 1) {
        return Ok(396);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_lexer_smoke_main(void)") != 1) {
        return Ok(397);
    }
    return Ok(42);
}

// SH-C-42 - bootstrap-emitted real-lexer radius C markers (gates 420-426).
fn fixture_bootstrap_real_lexer_radius_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_lexer_radius()?;
    if (str_contains(c_src, "/* SH-C-42 - bootstrap real-lexer radius */") != 1) {
        return Ok(420);
    }
    if (str_contains(c_src, "fx_Vec_i32 kinds") != 1) {
        return Ok(421);
    }
    if (str_contains(c_src, "fx_Vec_i32 vals") != 1) {
        return Ok(422);
    }
    if (str_contains(c_src, "fx_Vec_i32 lens") != 1) {
        return Ok(423);
    }
    if (str_contains(c_src, "fx_bootstrap_real_lexer_radius_push_tok") != 1) {
        return Ok(424);
    }
    if (str_contains(c_src, "fx_bootstrap_real_lexer_radius_is_space") != 1) {
        return Ok(425);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_real_lexer_radius_main(void)") != 1) {
        return Ok(426);
    }
    return Ok(42);
}

// SH-C-44 - bootstrap-emitted real-lexer full C markers (gates 430-437; genuine AST emit).
fn fixture_bootstrap_real_lexer_full_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_lexer_full()?;
    if (str_contains(c_src, "/* SH-C-44 - bootstrap real-lexer full (genuine emit) */") != 1) {
        return Ok(430);
    }
    if (str_contains(c_src, "fx_sh_lexer_TokBuf") != 1) {
        return Ok(431);
    }
    if (str_contains(c_src, "fx_sh_lexer_lex") != 1) {
        return Ok(432);
    }
    if (str_contains(c_src, "fx_sh_lexer_smoke_tests") != 1) {
        return Ok(433);
    }
    if (str_contains(c_src, "fx_sh_lexer_push_tok") != 1) {
        return Ok(434);
    }
    if (str_contains(c_src, "sh_lexer_lex body_len=") != 1) {
        return Ok(435);
    }
    if (str_contains(c_src, "sh_lexer_smoke_tests body_len=") != 1) {
        return Ok(436);
    }
    if (str_contains(c_src, "sh_lexer_TokBuf body_len=") != 1) {
        return Ok(437);
    }
    return Ok(42);
}


// SH-C-45 - bootstrap-emitted real-parse radius markers (gates 450-461; genuine AST emit).
fn fixture_bootstrap_real_parse_radius_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_radius()?;
    if (str_contains(c_src, "/* SH-C-45 - bootstrap real-parse radius (genuine emit) */") != 1) {
        return Ok(450);
    }
    if (str_contains(c_src, "fx_sh_parse_skip_module_preamble") != 1) {
        return Ok(451);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_import_decl") != 1) {
        return Ok(452);
    }
    if (str_contains(c_src, "fx_sh_parse_include_relative_h") != 1) {
        return Ok(453);
    }
    if (str_contains(c_src, "fx_sh_parse_map_type_span_to_c_mod") != 1) {
        return Ok(454);
    }
    if (str_contains(c_src, "fx_sh_parse_param_sig_has_kinds") != 1) {
        return Ok(455);
    }
    if (str_contains(c_src, "fx_sh_parse_ImpOut") != 1) {
        return Ok(456);
    }
    if (str_contains(c_src, "fx_sh_parse_ModOut") != 1) {
        return Ok(457);
    }
    if (str_contains(c_src, "fx_sh_parse_Result_ImpOut") != 1) {
        return Ok(458);
    }
    if (str_contains(c_src, "fx_sh_parse_strbuf_finish") != 1) {
        return Ok(459);
    }
    if (str_contains(c_src, "fx_sh_parse_bump_alloc") != 1) {
        return Ok(464);
    }
    if (str_contains(c_src, "(void)b;") == 1) {
        if (str_contains(c_src, "(void)s;") == 1) {
            return Ok(465);
        }
    }
    if (str_contains(c_src, "sh_parse_skip_module_preamble body_len=") != 1) {
        return Ok(460);
    }
    if (str_contains(c_src, "sh_parse_include_line_for_spec body_len=") != 1) {
        return Ok(461);
    }
    if (str_contains(c_src, "fx_sh_parse_radius_smoke_tests") != 1) {
        return Ok(466);
    }
    return Ok(42);
}

// SH-C-51 - bootstrap-emitted real-parse recursive markers (gates 490-503; genuine AST emit).
fn fixture_bootstrap_real_parse_recursive_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_recursive()?;
    if (str_contains(c_src, "/* SH-C-51 - bootstrap real-parse recursive (genuine emit) */") != 1) {
        return Ok(490);
    }
    if (str_contains(c_src, "fx_sh_parse_skip_module_preamble") != 1) {
        return Ok(491);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_ret_type") != 1) {
        return Ok(492);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_enum_def") != 1) {
        return Ok(493);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_struct_def") != 1) {
        return Ok(494);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_struct_fields_rest") != 1) {
        return Ok(495);
    }
    if (str_contains(c_src, "fx_sh_parse_RetTypeOut") != 1) {
        return Ok(496);
    }
    if (str_contains(c_src, "fx_sh_parse_EnumOut") != 1) {
        return Ok(497);
    }
    if (str_contains(c_src, "fx_sh_parse_StructOut") != 1) {
        return Ok(498);
    }
    if (str_contains(c_src, "fx_sh_parse_strbuf_finish") != 1) {
        return Ok(499);
    }
    if (str_contains(c_src, "fx_sh_parse_bump_alloc") != 1) {
        return Ok(500);
    }
    if (str_contains(c_src, "sh_parse_skip_module_preamble body_len=") != 1) {
        return Ok(501);
    }
    if (str_contains(c_src, "sh_parse_parse_ret_type body_len=") != 1) {
        return Ok(502);
    }
    if (str_contains(c_src, "fx_sh_parse_recursive_smoke_tests") != 1) {
        return Ok(503);
    }
    return Ok(42);
}

// SH-C-53 - bootstrap-emitted real-parse expr-stmt markers (gates 510-523; genuine AST emit).
fn fixture_bootstrap_real_parse_expr_stmt_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_expr_stmt()?;
    if (str_contains(c_src, "/* SH-C-53 - bootstrap real-parse expr-stmt (genuine emit) */") != 1) {
        return Ok(510);
    }
    if (str_contains(c_src, "fx_sh_parse_skip_module_preamble") != 1) {
        return Ok(511);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_factor") != 1) {
        return Ok(512);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_expr") != 1) {
        return Ok(513);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_cond") != 1) {
        return Ok(514);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_stmt") != 1) {
        return Ok(515);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_block") != 1) {
        return Ok(516);
    }
    if (str_contains(c_src, "fx_sh_parse_ParseOut") != 1) {
        return Ok(517);
    }
    if (str_contains(c_src, "fx_sh_parse_StmtStep") != 1) {
        return Ok(518);
    }
    if (str_contains(c_src, "fx_sh_parse_BlockParseOut") != 1) {
        return Ok(519);
    }
    if (str_contains(c_src, "fx_sh_parse_unpack_match_body") != 1) {
        return Ok(520);
    }
    if (str_contains(c_src, "fx_sh_parse_struct_lit_acc_push") != 1) {
        return Ok(521);
    }
    if (str_contains(c_src, "sh_parse_parse_factor body_len=") != 1) {
        return Ok(522);
    }
    if (str_contains(c_src, "fx_sh_parse_expr_stmt_smoke_tests") != 1) {
        return Ok(523);
    }
    return Ok(42);
}

// SH-C-73 - bootstrap-emitted real-parse boot smoke bodies (gates 526-603 + boot-body checks).
fn fixture_bootstrap_real_parse_fn_def_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_fn_def()?;
    if (str_contains(c_src, "/* SH-C-73 - bootstrap real-parse boot smoke bodies (genuine emit; extends SH-C-55/72) */") != 1) {
        return Ok(526);
    }
    if (str_contains(c_src, "fx_sh_parse_skip_module_preamble") != 1) {
        return Ok(527);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_fn_def") != 1) {
        return Ok(528);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_fn_params") != 1) {
        return Ok(529);
    }
    if (str_contains(c_src, "fx_sh_parse_void_param_sig") != 1) {
        return Ok(530);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_block") != 1) {
        return Ok(531);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_stmt") != 1) {
        return Ok(532);
    }
    if (str_contains(c_src, "fx_sh_parse_FnOut") != 1) {
        return Ok(533);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_expr") != 1) {
        return Ok(534);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_cond") != 1) {
        return Ok(535);
    }
    if (str_contains(c_src, "sh_parse_parse_fn_def body_len=") != 1) {
        return Ok(536);
    }
    if (str_contains(c_src, "fx_sh_parse_fn_def_smoke_tests") != 1) {
        return Ok(537);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_module_decl") != 1) {
        return Ok(538);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_enum_def") != 1) {
        return Ok(539);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_let_stmt") != 1) {
        return Ok(540);
    }
    if (str_contains(c_src, "fx_sh_parse_eval_expr") != 1) {
        return Ok(541);
    }
    if (str_contains(c_src, "fx_sh_parse_is_num") != 1) {
        return Ok(542);
    }
    if (str_contains(c_src, "fx_sh_parse_is_add") != 1) {
        return Ok(543);
    }
    if (str_contains(c_src, "fx_sh_parse_check_if_stmt") != 1) {
        return Ok(544);
    }
    if (str_contains(c_src, "fx_sh_parse_check_while_stmt") != 1) {
        return Ok(545);
    }
    if (str_contains(c_src, "fx_sh_parse_is_strlit") != 1) {
        return Ok(548);
    }
    if (str_contains(c_src, "fx_sh_parse_is_ident") != 1) {
        return Ok(549);
    }
    if (str_contains(c_src, "fx_sh_parse_check_fn_returns") != 1) {
        return Ok(550);
    }
    if (str_contains(c_src, "fx_sh_parse_stmt_ty_tag") != 1) {
        return Ok(551);
    }
    if (str_contains(c_src, "fx_sh_parse_stmt_let_expr_idx") != 1) {
        return Ok(552);
    }
    if (str_contains(c_src, "fx_sh_parse_expr_ty_tag") != 1) {
        return Ok(553);
    }
    if (str_contains(c_src, "fx_sh_parse_expr_binop_l") != 1) {
        return Ok(554);
    }
    if (str_contains(c_src, "fx_sh_parse_expr_is_call0") != 1) {
        return Ok(555);
    }
    if (str_contains(c_src, "fx_sh_parse_expr_ok_return_ident_name") != 1) {
        return Ok(556);
    }
    if (str_contains(c_src, "fx_sh_parse_typecheck_rejects_str_return") != 1) {
        return Ok(557);
    }
    if (str_contains(c_src, "fx_sh_parse_typecheck_accepts_ok_num_result_i32") != 1) {
        return Ok(558);
    }
    if (str_contains(c_src, "fx_sh_parse_typecheck_accepts_result_forward_struct") != 1) {
        return Ok(559);
    }
    if (str_contains(c_src, "fx_sh_parse_typecheck_fixture_tests") != 1) {
        return Ok(560);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_fn_sig_open_line") != 1) {
        return Ok(561);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_return_num_line") != 1) {
        return Ok(562);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_parser_expr_c") != 1) {
        return Ok(563);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_parser_break_line") != 1) {
        return Ok(564);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_struct_type_c_name") != 1) {
        return Ok(565);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_enum_typedef_block") != 1) {
        return Ok(566);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_let_add_idents_line") != 1) {
        return Ok(567);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_result_tag_defines") != 1) {
        return Ok(568);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_match_expr_c") != 1) {
        return Ok(569);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_meta_line") != 1) {
        return Ok(570);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_expr_c") != 1) {
        return Ok(571);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_genericstruct_main_template") != 1) {
        return Ok(572);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_importstdio_main_template") != 1) {
        return Ok(573);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_try_propagate_line") != 1) {
        return Ok(574);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_simple_main_template") != 1) {
        return Ok(575);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_add_main_template") != 1) {
        return Ok(576);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_hello_main_template") != 1) {
        return Ok(577);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_p2_file_io_main_template") != 1) {
        return Ok(578);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_using_core_main_template") != 1) {
        return Ok(579);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_sh_lexer_runtime_preamble") != 1) {
        return Ok(580);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_sh_parse_runtime_preamble") != 1) {
        return Ok(581);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_sh_emit_runtime_preamble") != 1) {
        return Ok(582);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_real_lexer_radius_main_body") != 1) {
        return Ok(583);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_sh_parse_expr_stmt_runtime_preamble") != 1) {
        return Ok(584);
    }
    if (str_contains(c_src, "fx_sh_parse_fixture_profile_ok_main") != 1) {
        return Ok(585);
    }
    if (str_contains(c_src, "fx_sh_parse_fixture_profile_tests") != 1) {
        return Ok(586);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_and_emit_ok_main") != 1) {
        return Ok(587);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_and_emit_ok_add") != 1) {
        return Ok(588);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_and_emit_bootstrap_self_subset") != 1) {
        return Ok(589);
    }
    if (str_contains(c_src, "fx_sh_parse_fixture_profile_ok_add") != 1) {
        return Ok(590);
    }
    if (str_contains(c_src, "fx_sh_parse_ty_kind_i32") != 1) {
        return Ok(591);
    }
    if (str_contains(c_src, "fx_sh_parse_type_diag_empty") != 1) {
        return Ok(592);
    }
    if (str_contains(c_src, "fx_sh_parse_TypeDiag") != 1) {
        return Ok(593);
    }
    if (str_contains(c_src, "fx_sh_parse_self_subset_tests") != 1) {
        return Ok(594);
    }
    if (str_contains(c_src, "fx_sh_parse_includes_zspec_core") != 1) {
        return Ok(595);
    }
    if (str_contains(c_src, "fx_Map_string_i32") != 1) {
        return Ok(596);
    }
    if (str_contains(c_src, "fx_sh_parse_map_nth_key") != 1) {
        return Ok(606);
    }
    if (str_contains(c_src, "fx_sh_parse_map_nth_value") != 1) {
        return Ok(607);
    }
    if (str_contains(c_src, "map_nth_key") != 1) {
        return Ok(608);
    }
    if (str_contains(c_src, "apply_index_postfix") != 1) {
        return Ok(609);
    }
    if (str_contains(c_src, "expr_index_base_idx") != 1) {
        return Ok(610);
    }
    if (str_contains(c_src, ".data[") != 1) {
        return Ok(611);
    }
    if (str_contains(c_src, "SliceRange") != 1) {
        return Ok(612);
    }
    if (str_contains(c_src, "expr_slice_lo_idx") != 1) {
        return Ok(613);
    }
    if (str_contains(c_src, "fx_Slice_i32") != 1) {
        return Ok(614);
    }
    if (str_contains(c_src, "fx_Buf") != 1) {
        return Ok(615);
    }
    if (str_contains(c_src, "fx_Bytes") != 1) {
        return Ok(616);
    }
    if (str_contains(c_src, "fx_sh_parse_buf_new") != 1) {
        return Ok(617);
    }
    if (str_contains(c_src, "buf_finish") != 1) {
        return Ok(618);
    }
    if (str_contains(c_src, "fx_Map_string_string") != 1) {
        return Ok(619);
    }
    if (str_contains(c_src, "map_new_ss") != 1) {
        return Ok(620);
    }
    if (str_contains(c_src, "map_insert_ss") != 1) {
        return Ok(621);
    }
    if (str_contains(c_src, "map_nth_value_ss") != 1) {
        return Ok(622);
    }
    if (str_contains(c_src, "fx_MutSlice_i32") != 1) {
        return Ok(623);
    }
    if (str_contains(c_src, "fx_sh_parse_type_span_is_mut_slice") != 1) {
        return Ok(624);
    }
    if (str_contains(c_src, "fx_sh_parse_type_span_is_array") != 1) {
        return Ok(625);
    }
    if (str_contains(c_src, "fx_sh_parse_map_mut_slice_type_c") != 1) {
        return Ok(626);
    }
    if (str_contains(c_src, "fx_sh_parse_emit_parser_index_assign_line") != 1) {
        return Ok(627);
    }
    if (str_contains(c_src, "FX-SH-NAT-7") != 1) {
        return Ok(628);
    }
    if (str_contains(c_src, "fx_sh_parse_type_span_is_map") != 1) {
        return Ok(597);
    }
    if (str_contains(c_src, "fx_sh_parse_map_map_type_c") != 1) {
        return Ok(598);
    }
    if (str_contains(c_src, "fx_sh_parse_c_keyword_map") != 1) {
        return Ok(599);
    }
    if (str_contains(c_src, "fx_sh_parse_env_lookup_i32") != 1) {
        return Ok(600);
    }
    if (str_contains(c_src, "fx_sh_parse_parse_fn_params_c") != 1) {
        return Ok(601);
    }
    if (str_contains(c_src, "fx_sh_parse_build_let_env_rec") != 1) {
        return Ok(602);
    }
    if (str_contains(c_src, "fx_sh_parse_check_fn_returns_with_struct_ret") != 1) {
        return Ok(603);
    }
    if (str_contains(c_src, "module sh_parse; import sh_lexer; enum Expr") != 1) {
        return Ok(604);
    }
    if (str_contains(c_src, "fx_sh_parse_smoke_tests") != 1) {
        return Ok(605);
    }
    if (str_contains(c_src, "\"1 + 2\"") != 1) {
        return Ok(606);
    }
    return Ok(42);
}





































// SH-C-46 - bootstrap-emitted real-emit radius markers (gates 470-486; genuine AST emit).
fn fixture_bootstrap_real_emit_radius_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_emit_radius()?;
    if (str_contains(c_src, "/* SH-C-46 - bootstrap real-emit radius (genuine emit) */") != 1) {
        return Ok(470);
    }
    if (str_contains(c_src, "fx_sh_emit_includes_stdint_stddef") != 1) {
        return Ok(471);
    }
    if (str_contains(c_src, "fx_sh_emit_emit_result_base_typedefs") != 1) {
        return Ok(472);
    }
    if (str_contains(c_src, "fx_sh_emit_emit_meta_line") != 1) {
        return Ok(473);
    }
    if (str_contains(c_src, "fx_sh_emit_str_contains") != 1) {
        return Ok(474);
    }
    if (str_contains(c_src, "FX_RESULT_TAG_OK") != 1) {
        return Ok(475);
    }
    if (str_contains(c_src, "Result_string") != 1) {
        return Ok(476);
    }
    if (str_contains(c_src, "body_len=") != 1) {
        return Ok(477);
    }
    if (str_contains(c_src, "fx_sh_emit_bump_alloc") != 1) {
        return Ok(478);
    }
    if (str_contains(c_src, "fx_sh_emit_strbuf_finish") != 1) {
        return Ok(479);
    }
    if (str_contains(c_src, "sh_emit_probe body_len=") != 1) {
        return Ok(480);
    }
    if (str_contains(c_src, "fx_sh_emit_emit_strbuf_typedef_and_helpers") != 1) {
        return Ok(481);
    }
    if (str_contains(c_src, "sh_emit_includes_stdint_stddef body_len=") != 1) {
        return Ok(482);
    }
    if (str_contains(c_src, "sh_emit_emit_meta_line body_len=") != 1) {
        return Ok(483);
    }
    if (str_contains(c_src, "fx_sh_emit_radius_smoke_tests") != 1) {
        return Ok(486);
    }
    return Ok(42);
}

// SH-C-77/78/79/80 - bootstrap-emitted real-emit module markers (gates 610-624 + 628-639 + 640-657 + 658-675; genuine emit).
fn fixture_bootstrap_real_emit_module_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_emit_module()?;
    if (str_contains(c_src, "/* SH-C-77 - bootstrap real-emit module (genuine emit; production ok/roundtrip band) */") != 1) {
        return Ok(610);
    }
    if (str_contains(c_src, "fx_sh_emit_str_contains") != 1) {
        return Ok(611);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_ok_main_tests") != 1) {
        return Ok(612);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_ok_add_tests") != 1) {
        return Ok(613);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_ok_hello_tests") != 1) {
        return Ok(614);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_ok_char_lit_tests") != 1) {
        return Ok(615);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_ok_main") != 1) {
        return Ok(616);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_ok_add") != 1) {
        return Ok(617);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_ok_char_lit") != 1) {
        return Ok(618);
    }
    if (str_contains(c_src, "fx_lib_sh_parse_parse_and_emit_ok_main") != 1) {
        return Ok(619);
    }
    if (str_contains(c_src, "fx_lib_sh_parse_parse_and_emit_ok_add") != 1) {
        return Ok(620);
    }
    if (str_contains(c_src, "core_fs_write_text") != 1) {
        return Ok(621);
    }
    if (str_contains(c_src, "fx_sh_emit_emit_module_smoke_tests") != 1) {
        return Ok(622);
    }
    if (str_contains(c_src, "genuine emit") != 1) {
        return Ok(623);
    }
    if (str_contains(c_src, "SH-C-77") != 1) {
        return Ok(624);
    }
    if (str_contains(c_src, "/* SH-C-78 - REAL-EMIT-EXPORT wave 2 (bootstrap fixture/roundtrip band) */") != 1) {
        return Ok(628);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_bootstrap_lexer_smoke_tests") != 1) {
        return Ok(629);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_bootstrap_real_lexer_full_tests") != 1) {
        return Ok(630);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_bootstrap_real_parse_fn_def_tests") != 1) {
        return Ok(631);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_bootstrap_real_emit_radius_tests") != 1) {
        return Ok(632);
    }
    if (str_contains(c_src, "fx_sh_emit_fixture_bootstrap_self_subset_tests") != 1) {
        return Ok(633);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_bootstrap_lexer_smoke") != 1) {
        return Ok(634);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_bootstrap_real_parse_radius") != 1) {
        return Ok(635);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_bootstrap_self_subset") != 1) {
        return Ok(636);
    }
    if (str_contains(c_src, "fx_sh_emit_emit_bootstrap_self_subset_tests") != 1) {
        return Ok(637);
    }
    if (str_contains(c_src, "fx_sh_emit_emit_fixture_tests") != 1) {
        return Ok(638);
    }
    if (str_contains(c_src, "SH-C-78") != 1) {
        return Ok(639);
    }
    if (str_contains(c_src, "/* SH-C-79 - REAL-EMIT-EXPORT wave 3 (roundtrip_write_*_main_template band) */") != 1) {
        return Ok(640);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_simple_main_template") != 1) {
        return Ok(641);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_add_main_template") != 1) {
        return Ok(642);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_hello_main_template") != 1) {
        return Ok(643);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_struct_field_main_template") != 1) {
        return Ok(644);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_color_match_main_template") != 1) {
        return Ok(645);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_enum_payload_main_template") != 1) {
        return Ok(646);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_vec_enum_main_template") != 1) {
        return Ok(647);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_defer_main_template") != 1) {
        return Ok(648);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_bits_main_template") != 1) {
        return Ok(649);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_array_main_template") != 1) {
        return Ok(650);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_regmatch_main_template") != 1) {
        return Ok(651);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_fxnested_main_template") != 1) {
        return Ok(652);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_tripletry_main_template") != 1) {
        return Ok(653);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_fxtrynodefer_main_template") != 1) {
        return Ok(654);
    }
    if (str_contains(c_src, "fx_lib_sh_parse_emit_simple_main_template") != 1) {
        return Ok(655);
    }
    if (str_contains(c_src, "bootstrap_fxtrynodefer_main.c.in") != 1) {
        return Ok(656);
    }
    if (str_contains(c_src, "SH-C-79") != 1) {
        return Ok(657);
    }
    if (str_contains(c_src, "/* SH-C-80 - REAL-EMIT-EXPORT wave 4 (export closure: defer/arena+generic+import+fixtures) */") != 1) {
        return Ok(658);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_defertryarena_main_template") != 1) {
        return Ok(659);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_deferwhile_main_template") != 1) {
        return Ok(660);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_deferarena_main_template") != 1) {
        return Ok(661);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_arena_main_template") != 1) {
        return Ok(662);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_tempderef_main_template") != 1) {
        return Ok(663);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_fxregion_main_template") != 1) {
        return Ok(664);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_arenaborrowempty_main_template") != 1) {
        return Ok(665);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_genericstruct_main_template") != 1) {
        return Ok(666);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_genericvec_main_template") != 1) {
        return Ok(667);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_genericvecget_main_template") != 1) {
        return Ok(668);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_importgenericstruct_main_template") != 1) {
        return Ok(669);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_importstdvec_main_template") != 1) {
        return Ok(670);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_importstdiofile_main_template") != 1) {
        return Ok(671);
    }
    if (str_contains(c_src, "fx_sh_emit_roundtrip_write_fixtures") != 1) {
        return Ok(672);
    }
    if (str_contains(c_src, "fx_lib_sh_parse_emit_defertryarena_main_template") != 1) {
        return Ok(673);
    }
    if (str_contains(c_src, "bootstrap_importstdiofile_main.c.in") != 1) {
        return Ok(674);
    }
    if (str_contains(c_src, "SH-C-80") != 1) {
        return Ok(675);
    }
    return Ok(42);
}






// SH-C-29 - bootstrap-emitted parse-family C markers (gates 400-406).
fn fixture_bootstrap_parse_smoke_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_parse_smoke()?;
    if (str_contains(c_src, "/* SH-C-29 - bootstrap parse-family smoke */") != 1) {
        return Ok(400);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_parse_smoke_parse_expr(int32_t a, int32_t b)") != 1) {
        return Ok(401);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_parse_smoke_parse_stmt(int32_t a, int32_t b)") != 1) {
        return Ok(402);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_parse_smoke_parse(int32_t a, int32_t b)") != 1) {
        return Ok(403);
    }
    if (str_contains(c_src, "fx_bootstrap_parse_smoke_parse(40, 2)") != 1) {
        return Ok(404);
    }
    if (str_contains(c_src, "bootstrap_parse_smoke_parse body_len=1") != 1) {
        return Ok(405);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_parse_smoke_main(void)") != 1) {
        return Ok(406);
    }
    return Ok(42);
}

// SH-C-30 - bootstrap-emitted emit-family C markers (gates 409-416).
fn fixture_bootstrap_emit_smoke_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_emit_smoke()?;
    if (str_contains(c_src, "/* SH-C-30 - bootstrap emit-family smoke */") != 1) {
        return Ok(409);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_emit_smoke_emit_line(int32_t a, int32_t b)") != 1) {
        return Ok(410);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_emit_smoke_emit_fn(int32_t a, int32_t b)") != 1) {
        return Ok(411);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_emit_smoke_emit_file(int32_t a, int32_t b)") != 1) {
        return Ok(412);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_emit_smoke_emit(int32_t a, int32_t b)") != 1) {
        return Ok(413);
    }
    if (str_contains(c_src, "fx_bootstrap_emit_smoke_emit(40, 2)") != 1) {
        return Ok(414);
    }
    if (str_contains(c_src, "bootstrap_emit_smoke_emit body_len=1") != 1) {
        return Ok(415);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_emit_smoke_main(void)") != 1) {
        return Ok(416);
    }
    return Ok(42);
}

fn fixture_ok_hello_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_hello()?;
    if (str_contains(c_src, "#include <stdio.h>") != 1) {
        return Ok(86);
    }
    if (str_contains(c_src, "int32_t fx_ok_hello_main") != 1) {
        return Ok(87);
    }
    if (str_contains(c_src, "puts(\"hello\")") != 1) {
        return Ok(88);
    }
    if (str_contains(c_src, "return 0") != 1) {
        return Ok(89);
    }
    if (str_contains(c_src, "ok_hello body_len=2") != 1) {
        return Ok(90);
    }
    return Ok(42);
}

fn fixture_ok_import_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_import()?;
    if (str_contains(c_src, "#include <stdint.h>") != 1) {
        return Ok(110);
    }
    if (str_contains(c_src, "#include \"math.h\"") != 1) {
        return Ok(111);
    }
    if (str_contains(c_src, "int32_t fx_ok_import_main") != 1) {
        return Ok(112);
    }
    if (str_contains(c_src, "fx_math_add(1, 2)") != 1) {
        return Ok(113);
    }
    if (str_contains(c_src, "ok_import body_len=1") != 1) {
        return Ok(114);
    }
    let math_src: string = sh_parse.parse_and_emit_bootstrap_math()?;
    if (str_contains(math_src, "return (a + b)") != 1) {
        return Ok(115);
    }
    if (str_contains(math_src, "int32_t fx_math_add(int32_t a, int32_t b)") != 1) {
        return Ok(116);
    }
    return Ok(42);
}

fn fixture_ok_color_match_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_color_match()?;
    if (str_contains(c_src, "fx_ok_color_match_Color") != 1) {
        return Ok(130);
    }
    if (str_contains(c_src, "FX_OK_COLOR_MATCH_COLOR_GREEN") != 1) {
        return Ok(131);
    }
    if (str_contains(c_src, "int32_t fx_ok_color_match_tag") != 1) {
        return Ok(132);
    }
    if (str_contains(c_src, "int32_t fx_ok_color_match_main(void)") != 1) {
        return Ok(138);
    }
    if (str_contains(c_src, "case FX_OK_COLOR_MATCH_COLOR_GREEN") != 1) {
        return Ok(137);
    }
    if (str_contains(c_src, "switch (_scrutinee)") != 1) {
        return Ok(133);
    }
    if (str_contains(c_src, "fx_ok_color_match_tag(FX_OK_COLOR_MATCH_COLOR_GREEN)") != 1) {
        return Ok(134);
    }
    if (str_contains(c_src, "ok_color_match_tag body_len=1") != 1) {
        return Ok(135);
    }
    if (str_contains(c_src, "ok_color_match_main body_len=1") != 1) {
        return Ok(136);
    }
    if (str_contains(c_src, "_match_result = 1") != 1) {
        return Ok(139);
    }
    if (str_contains(c_src, "case FX_OK_COLOR_MATCH_COLOR_RED") != 1) {
        return Ok(140);
    }
    return Ok(42);
}

fn fixture_ok_band_match_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_band_match()?;
    if (str_contains(c_src, "fx_ok_band_match_Band") != 1) {
        return Ok(140);
    }
    if (str_contains(c_src, "FX_OK_BAND_MATCH_BAND_HIGH") != 1) {
        return Ok(141);
    }
    if (str_contains(c_src, "case FX_OK_BAND_MATCH_BAND_HIGH") != 1) {
        return Ok(142);
    }
    if (str_contains(c_src, "fx_ok_band_match_tag(FX_OK_BAND_MATCH_BAND_HIGH)") != 1) {
        return Ok(143);
    }
    if (str_contains(c_src, "int32_t fx_ok_band_match_main(void)") != 1) {
        return Ok(144);
    }
    if (str_contains(c_src, "_match_result = 1") != 1) {
        return Ok(145);
    }
    if (str_contains(c_src, "case FX_OK_BAND_MATCH_BAND_LOW") != 1) {
        return Ok(146);
    }
    return Ok(42);
}

fn fixture_ok_enum_payload_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.enum_payload_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload()?;
    if (str_contains(c_src, "fx_ok_enum_payload_MsgTag") != 1) {
        return Ok(160);
    }
    if (str_contains(c_src, "FX_OK_ENUM_PAYLOAD_MSG_TAG_NUM") != 1) {
        return Ok(161);
    }
    if (str_contains(c_src, "switch (_scrutinee.tag)") != 1) {
        return Ok(162);
    }
    if (str_contains(c_src, "_scrutinee.u.num") != 1) {
        return Ok(163);
    }
    if (str_contains(c_src, ".tag = FX_OK_ENUM_PAYLOAD_MSG_TAG_NUM") != 1) {
        return Ok(164);
    }
    if (str_contains(c_src, "int32_t fx_ok_enum_payload_main(void)") != 1) {
        return Ok(165);
    }
    if (str_contains(c_src, "_match_result = 99") != 1) {
        return Ok(166);
    }
    if (str_contains(c_src, "case FX_OK_ENUM_PAYLOAD_MSG_TAG_STOP") != 1) {
        return Ok(167);
    }
    return Ok(42);
}

fn fixture_ok_struct_field_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_struct_field()?;
    if (str_contains(c_src, "fx_ok_struct_field_Point") != 1) {
        return Ok(150);
    }
    if (str_contains(c_src, "return (p.x + p.y)") != 1) {
        return Ok(151);
    }
    if (str_contains(c_src, "fx_ok_struct_field_sum((fx_ok_struct_field_Point){ .x = 10, .y = 32 })") != 1) {
        return Ok(152);
    }
    if (str_contains(c_src, "int32_t fx_ok_struct_field_main(void)") != 1) {
        return Ok(153);
    }
    if (str_contains(c_src, "int32_t x") != 1) {
        return Ok(154);
    }
    if (str_contains(c_src, "int32_t y") != 1) {
        return Ok(155);
    }
    return Ok(42);
}

fn fixture_ok_struct_return_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_struct_return()?;
    if (str_contains(c_src, "fx_ok_struct_return_Eval") != 1) {
        return Ok(101);
    }
    if (str_contains(c_src, "fx_ok_struct_return_step(int32_t pos)") != 1) {
        return Ok(102);
    }
    if (str_contains(c_src, ".value = (pos * 2)") != 1) {
        return Ok(103);
    }
    if (str_contains(c_src, "fx_ok_struct_return_Eval a = fx_ok_struct_return_step(start)") != 1) {
        return Ok(104);
    }
    if (str_contains(c_src, "fx_ok_struct_return_twice(5)") != 1) {
        return Ok(105);
    }
    if (str_contains(c_src, "int32_t fx_ok_struct_return_main(void)") != 1) {
        return Ok(106);
    }
    if (str_contains(c_src, "fx_ok_struct_return_step(a.pos)") != 1) {
        return Ok(107);
    }
    if (str_contains(c_src, "return (a.value + b.value)") != 1) {
        return Ok(108);
    }
    return Ok(42);
}

fn fixture_bootstrap_self_subset_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    return emit_bootstrap_self_subset_tests();
}

// CONV-2-g.13 -- emit + str_contains gates (holds megabyte c_src; L3 only).
fn emit_bootstrap_self_subset_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_self_subset()?;
    if (str_contains(c_src, "#include \"sh_lexer.h\"") != 1) {
        return Ok(109);
    }
    if (str_contains(c_src, "#include \"../std/fx_defaults.h\"") != 1) {
        return Ok(120);
    }
    if (str_contains(c_src, "#include \"../std/string.h\"") != 1) {
        return Ok(121);
    }
    if (str_contains(c_src, "#include \"sh_diag.h\"") != 1) {
        return Ok(119);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_self_subset_stop_code(void)") != 1) {
        return Ok(126);
    }
    if (str_contains(c_src, "bootstrap_self_subset_stop_code body_len=1") != 1) {
        return Ok(127);
    }
    if (str_contains(c_src, "    return 99;\n") != 1) {
        return Ok(128);
    }
    if (str_contains(c_src, "_match_result = fx_bootstrap_self_subset_stop_code();") != 1) {
        return Ok(129);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_self_subset_pass(int32_t n)") != 1) {
        return Ok(130);
    }
    if (str_contains(c_src, "bootstrap_self_subset_pass body_len=2") != 1) {
        return Ok(131);
    }
    if (str_contains(c_src, "    int32_t v = n;\n") != 1) {
        return Ok(132);
    }
    if (str_contains(c_src, "    return v;\n") != 1) {
        return Ok(133);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_self_subset_add1(int32_t a, int32_t b)") != 1) {
        return Ok(135);
    }
    if (str_contains(c_src, "bootstrap_self_subset_add1 body_len=3") != 1) {
        return Ok(136);
    }
    if (str_contains(c_src, "    int32_t s = (a + b);\n") != 1) {
        return Ok(137);
    }
    if (str_contains(c_src, "    int32_t t = s;\n") != 1) {
        return Ok(140);
    }
    if (str_contains(c_src, "    return t;\n") != 1) {
        return Ok(141);
    }
    if (str_contains(c_src, "_match_result = fx_bootstrap_self_subset_add1(fx_bootstrap_self_subset_pass(n), 0);") != 1) {
        return Ok(139);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string") != 1) {
        return Ok(142);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_golden_path(void)") != 1) {
        return Ok(143);
    }
    if (str_contains(c_src, "bootstrap_self_subset_golden_path body_len=1") != 1) {
        return Ok(144);
    }
    if (str_contains(c_src, "    return (fx_bootstrap_self_subset_Result_string){ .tag = FX_RESULT_TAG_OK, .ok_val = \"bootstrap_self_subset.fx\", .err_val = CORE_OK };\n") != 1) {
        return Ok(145);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_load_src(void)") != 1) {
        return Ok(146);
    }
    if (str_contains(c_src, "bootstrap_self_subset_load_src body_len=2") != 1) {
        return Ok(147);
    }
    if (str_contains(c_src, "    fx_bootstrap_self_subset_Result_string __try_0 = fx_bootstrap_self_subset_golden_path();\n") != 1) {
        return Ok(148);
    }
    if (str_contains(c_src, "    if (__try_0.tag != FX_RESULT_TAG_OK) {\n        return __try_0;\n    }\n") != 1) {
        return Ok(149);
    }
    if (str_contains(c_src, "    const char* path = __try_0.ok_val;\n") != 1) {
        return Ok(150);
    }
    if (str_contains(c_src, "static fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_fs_read_text(const char* path)") != 1) {
        return Ok(153);
    }
    if (str_contains(c_src, "    return fx_bootstrap_self_subset_fs_read_text(path);\n") != 1) {
        return Ok(154);
    }
    if (str_contains(c_src, "#include <stdio.h>") != 1) {
        return Ok(155);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_i32") != 1) {
        return Ok(156);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_i32 fx_bootstrap_self_subset_check_tag_ok(void)") != 1) {
        return Ok(157);
    }
    if (str_contains(c_src, "bootstrap_self_subset_check_tag_ok body_len=2") != 1) {
        return Ok(158);
    }
    if (str_contains(c_src, "    int32_t v = fx_bootstrap_self_subset_tag((fx_bootstrap_self_subset_Expr)") != 1) {
        return Ok(159);
    }
    if (str_contains(c_src, "    return (fx_bootstrap_self_subset_Result_i32){ .tag = FX_RESULT_TAG_OK, .ok_val = v, .err_val = CORE_OK };\n") != 1) {
        return Ok(160);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_i32 fx_bootstrap_self_subset_parse_smoke(void)") != 1) {
        return Ok(161);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_smoke body_len=3") != 1) {
        return Ok(162);
    }
    if (str_contains(c_src, "    uint8_t r_scratch[16384]; /* region r */") != 1) {
        return Ok(163);
    }
    if (str_contains(c_src, "    (void)r_scratch;\n    int32_t v = fx_bootstrap_self_subset_tag((fx_bootstrap_self_subset_Expr)") != 1) {
        return Ok(164);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_ModOut;\n") != 1) {
        return Ok(165);
    }
    if (str_contains(c_src, "    int32_t path_off;\n") != 1) {
        return Ok(166);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_ImpOut;\n") != 1) {
        return Ok(167);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_self_subset_wrap(int32_t n)") != 1) {
        return Ok(168);
    }
    if (str_contains(c_src, "bootstrap_self_subset_wrap body_len=1") != 1) {
        return Ok(169);
    }
    if (str_contains(c_src, "    return fx_bootstrap_self_subset_pass(n);\n") != 1) {
        return Ok(170);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_StmtTag") != 1) {
        return Ok(171);
    }
    if (str_contains(c_src, "        int32_t return_;\n") != 1) {
        return Ok(172);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_TopItem;\n") != 1) {
        return Ok(173);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_LetOut;\n") != 1) {
        return Ok(174);
    }
    if (str_contains(c_src, "    int32_t variant_count;\n") != 1) {
        return Ok(175);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_RetTypeOut;\n") != 1) {
        return Ok(176);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_ModOut;\n") != 1) {
        return Ok(177);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_ImpOut;\n") != 1) {
        return Ok(178);
    }
    if (str_contains(c_src, "} fx_Vec_i32;\n") != 1) {
        return Ok(185);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut fx_bootstrap_self_subset_parse_path_span(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos)") != 1) {
        return Ok(211);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_path_span body_len=20") != 1) {
        return Ok(212);
    }
    if (str_contains(c_src, "    while (") != 1) {
        return Ok(213);
    }
    if (str_contains(c_src, "        break;\n") != 1) {
        return Ok(214);
    }
    if (str_contains(c_src, "kinds.data[") != 1) {
        return Ok(215);
    }
    if (str_contains(c_src, "(*pos)") != 1) {
        return Ok(216);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ModOut fx_bootstrap_self_subset_parse_module_decl(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos)") != 1) {
        return Ok(179);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_module_decl body_len=19") != 1) {
        return Ok(180);
    }
    if (str_contains(c_src, "{ .name_off = name_off, .name_len = name_len }") != 1) {
        return Ok(181);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut fx_bootstrap_self_subset_parse_type_ident(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos)") != 1) {
        return Ok(182);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_type_ident body_len=9") != 1) {
        return Ok(183);
    }
    if (str_contains(c_src, "{ .path_off = off, .path_len = ln }") != 1) {
        return Ok(184);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut fx_bootstrap_self_subset_parse_import_decl(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos)") != 1) {
        return Ok(217);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_import_decl body_len=13") != 1) {
        return Ok(218);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut __try_0 = fx_bootstrap_self_subset_parse_path_span(kinds, vals, lens, pos);") != 1) {
        return Ok(219);
    }
    if (str_contains(c_src, "    fx_bootstrap_self_subset_ImpOut path = __try_0.ok_val;") != 1) {
        return Ok(220);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut fx_bootstrap_self_subset_parse_type_span_inner(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos)") != 1) {
        return Ok(221);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_type_span_inner body_len=29") != 1) {
        return Ok(222);
    }
    if (str_contains(c_src, "fx_lib_sh_lexer_slice_eq(src, start_off, start_ln, \"Vec\")") != 1) {
        return Ok(223);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut fx_bootstrap_self_subset_parse_type_span(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos)") != 1) {
        return Ok(224);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_type_span body_len=17") != 1) {
        return Ok(225);
    }
    if (str_contains(c_src, "    return fx_bootstrap_self_subset_parse_type_span_inner(kinds, vals, lens, src, pos);") != 1) {
        return Ok(226);
    }
    if (str_contains(c_src, "    int32_t span_off = (inner.path_off - 5);") != 1) {
        return Ok(227);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_i32 fx_bootstrap_self_subset_parse_effects_clause(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos)") != 1) {
        return Ok(228);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_effects_clause body_len=26") != 1) {
        return Ok(229);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_parse_effects_clause(fx_Vec_i32 kinds") == 1) {
        if (str_contains(c_src, "    while (") != 1) {
            return Ok(230);
        }
    }
    if (str_contains(c_src, ".ok_val = count, .err_val = CORE_OK }") != 1) {
        return Ok(231);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_RetTypeOut fx_bootstrap_self_subset_ret_type_zero(void)") != 1) {
        return Ok(232);
    }
    if (str_contains(c_src, "bootstrap_self_subset_ret_type_zero body_len=1") != 1) {
        return Ok(233);
    }
    if (str_contains(c_src, ".ret_err_len = 0") != 1) {
        return Ok(234);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_RetTypeOut fx_bootstrap_self_subset_try_imp_for_ret(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos)") != 1) {
        return Ok(235);
    }
    if (str_contains(c_src, "bootstrap_self_subset_try_imp_for_ret body_len=2") != 1) {
        return Ok(236);
    }
    if (str_contains(c_src, "    fx_bootstrap_self_subset_ImpOut out = __try_0.ok_val;") != 1) {
        return Ok(237);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ImpOut __try_0 = fx_bootstrap_self_subset_parse_type_ident(kinds, vals, lens, pos);") != 1) {
        return Ok(238);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_RetTypeOut fx_bootstrap_self_subset_parse_ret_type(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos)") != 1) {
        return Ok(239);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_ret_type body_len=46") != 1) {
        return Ok(240);
    }
    if (str_contains(c_src, "if ((((*pos) + 1) < n))") != 1) {
        return Ok(241);
    }
    if (str_contains(c_src, "    ret_ok_off = ok_ty.path_off;") != 1) {
        return Ok(242);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_i32 fx_bootstrap_self_subset_parse_using_decl(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos)") != 1) {
        return Ok(243);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_using_decl body_len=19") != 1) {
        return Ok(244);
    }
    if (str_contains(c_src, "fx_lib_sh_lexer_slice_eq(src, vals.data[(*pos)], lens.data[(*pos)], \"using\")") != 1) {
        return Ok(245);
    }
    if (str_contains(c_src, ".ok_val = 1, .err_val = CORE_OK };\n}\n\n/* fx bootstrap emit: bootstrap_self_subset_map_type_span_to_c") != 1) {
        return Ok(246);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_map_type_span_to_c(const char* src, int32_t off, int32_t ln)") != 1) {
        return Ok(261);
    }
    if (str_contains(c_src, "bootstrap_self_subset_map_type_span_to_c body_len=5") != 1) {
        return Ok(262);
    }
    if (str_contains(c_src, "bootstrap_self_subset_is_c_keyword_word body_len=2") != 1) {
        return Ok(263);
    }
    if (str_contains(c_src, "bootstrap_self_subset_variant_union_field_name body_len=35") != 1) {
        return Ok(264);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_str_from_i32(int32_t n)") != 1) {
        return Ok(265);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_parse_enum_variant_payload_spec(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos, const char* vname)") != 1) {
        return Ok(258);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_enum_variant_payload_spec body_len=46") != 1) {
        return Ok(259);
    }
    if (str_contains(c_src, "    break;\n") != 1) {
        return Ok(266);
    }
    if (str_contains(c_src, "if ((fx_std_string_len(pspec) != 0))") != 1) {
        return Ok(267);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_StructOut;\n") != 1) {
        return Ok(268);
    }
    if (str_contains(c_src, "    const char* fields_env;\n} fx_bootstrap_self_subset_StructOut;\n") != 1) {
        return Ok(269);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_StructOut fx_bootstrap_self_subset_parse_struct_fields_rest(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos, fx_bootstrap_self_subset_StrBuilder buf, int32_t field_count)") != 1) {
        return Ok(270);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_struct_fields_rest body_len=24") != 1) {
        return Ok(271);
    }
    if (str_contains(c_src, ".field_count = field_count, .fields_env = fx_bootstrap_self_subset_strbuf_finish(buf) }") != 1) {
        return Ok(272);
    }
    if (str_contains(c_src, "    (void)_ty;\n") != 1) {
        return Ok(273);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_parse_struct_fields_rest(kinds, vals, lens, src, pos, pushed2, (field_count + 1));\n}\n\n/* fx bootstrap emit: bootstrap_self_subset_parse_struct_def") != 1) {
        return Ok(274);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_StructOut fx_bootstrap_self_subset_parse_struct_def(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos)") != 1) {
        return Ok(275);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_struct_def body_len=15") != 1) {
        return Ok(276);
    }
    if (str_contains(c_src, "if ((kinds.data[(*pos)] != 34))") != 1) {
        return Ok(277);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_StructOut __try_1 = fx_bootstrap_self_subset_parse_struct_fields_rest(kinds, vals, lens, src, pos, empty_buf, 0);") != 1) {
        return Ok(278);
    }
    if (str_contains(c_src, ".field_count = rest.field_count, .fields_env = rest.fields_env }") != 1) {
        return Ok(279);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_FnSigOut;\n") != 1) {
        return Ok(280);
    }
    if (str_contains(c_src, "    int32_t param_tok_pos;\n    int32_t body_start;\n    int32_t body_len;\n} fx_bootstrap_self_subset_FnSigOut;\n") != 1) {
        return Ok(281);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_FnOut;\n") != 1) {
        return Ok(282);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_FnOut fx_bootstrap_self_subset_parse_fn_def(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, const char* mod_slug, int32_t* pos, fx_Vec_Expr nodes, fx_Vec_Stmt stmts)") != 1) {
        return Ok(283);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_fn_def body_len=30") != 1) {
        return Ok(284);
    }
    if (str_contains(c_src, "    int32_t body_start = (int32_t)stmts.len;\n") != 1) {
        return Ok(285);
    }
    if (str_contains(c_src, "if ((kinds.data[(*pos)] != 21))") != 1) {
        return Ok(286);
    }
    if (str_contains(c_src, "    int32_t param_tok_pos = (*pos);\n") != 1) {
        return Ok(287);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_i32 __try_2 = fx_bootstrap_self_subset_parse_effects_clause(kinds, vals, lens, pos);") != 1) {
        return Ok(288);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_BlockParseOut __try_3 = fx_bootstrap_self_subset_parse_block(kinds, vals, lens, pos, nodes, stmts);") != 1) {
        return Ok(289);
    }
    if (str_contains(c_src, ".nodes = body_blk.nodes, .stmts = body_blk.stmts }, .err_val = CORE_OK };\n}\n\nint32_t fx_bootstrap_self_subset_stop_code(void)") != 1) {
        return Ok(290);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_BlockParseOut fx_bootstrap_self_subset_parse_block(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes, fx_Vec_Stmt stmts)") != 1) {
        return Ok(291);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_block body_len=8") != 1) {
        return Ok(292);
    }
    if (str_contains(c_src, "    (void)nodes;\n    (void)stmts;\n") != 1) {
        return Ok(293);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_FnSigOut;\n\ntypedef struct {\n    int32_t name_off;\n    int32_t name_len;\n    int32_t ret_off;\n") != 1) {
        return Ok(294);
    }
    if (str_contains(c_src, "    const char* param_sig;\n    const char* param_env;\n") != 1) {
        return Ok(295);
    }
    if (str_contains(c_src, "    fx_Vec_Expr nodes;\n    fx_Vec_Stmt stmts;\n} fx_bootstrap_self_subset_FnOut;\n") != 1) {
        return Ok(296);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParamParseOut fx_bootstrap_self_subset_parse_fn_params(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, const char* mod_slug, int32_t* pos)") != 1) {
        return Ok(297);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_fn_params body_len=11") != 1) {
        return Ok(298);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string __try_0 = fx_bootstrap_self_subset_void_param_sig();") != 1) {
        return Ok(299);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParamParseOut fx_bootstrap_self_subset_parse_fn_params_nonempty(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, const char* mod_slug, int32_t* pos, const char* prefix, const char* env, int32_t first)") != 1) {
        return Ok(300);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_fn_params_nonempty body_len=33") != 1) {
        return Ok(301);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParamParseOut __try_0 = fx_bootstrap_self_subset_parse_fn_params(kinds, vals, lens, src, mod_slug, pos);") != 1) {
        return Ok(302);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_ParamParseOut params = __try_0.ok_val;") != 1) {
        return Ok(303);
    }
    if (str_contains(c_src, ".param_sig = params.sig, .param_env = params.env, .param_tok_pos = param_tok_pos") != 1) {
        return Ok(304);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_concat_param_acc(const char* prefix, const char* part2, int32_t first)") != 1) {
        return Ok(305);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_void_param_sig(void)") != 1) {
        return Ok(306);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string fx_bootstrap_self_subset_close_param_sig(const char* acc)") != 1) {
        return Ok(307);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_parse_fn_params_nonempty(kinds, vals, lens, src, mod_slug, pos, acc, env2, 0);") != 1) {
        return Ok(308);
    }
    if (str_contains(c_src, "    fx_Vec_Expr nodes;\n    fx_Vec_Stmt stmts;\n} fx_bootstrap_self_subset_BlockParseOut;\n") != 1) {
        return Ok(309);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_BlockParseOut;\n") != 1) {
        return Ok(310);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_BlockParseOut body_blk = __try_3.ok_val;") != 1) {
        return Ok(311);
    }
    if (str_contains(c_src, ".body_len = body_blk.count, .nodes = body_blk.nodes, .stmts = body_blk.stmts") != 1) {
        return Ok(312);
    }
    if (str_contains(c_src, "return (fx_bootstrap_self_subset_Result_BlockParseOut){ .tag = FX_RESULT_TAG_OK, .ok_val = (fx_bootstrap_self_subset_BlockParseOut){ .count = count, .nodes = nodes, .stmts = stmts }, .err_val = CORE_OK };") != 1) {
        return Ok(313);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_StmtStep;\n") != 1) {
        return Ok(314);
    }
    if (str_contains(c_src, "    fx_Vec_Expr nodes;\n    fx_Vec_Stmt stmts;\n} fx_bootstrap_self_subset_StmtStep;\n") != 1) {
        return Ok(315);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_vec_Stmt_push_val(core_Allocator* region, fx_Vec_Stmt v, fx_bootstrap_self_subset_Stmt val)") != 1) {
        return Ok(316);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_StmtStep fx_bootstrap_self_subset_parse_stmt(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes, fx_Vec_Stmt stmts)") != 1) {
        return Ok(317);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_stmt body_len=183") != 1) {
        return Ok(318);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_BREAK });") != 1) {
        return Ok(319);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_BlockParseOut fx_bootstrap_self_subset_parse_block_rest(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes, fx_Vec_Stmt stmts, int32_t start)") != 1) {
        return Ok(320);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_block_rest body_len=9") != 1) {
        return Ok(321);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_StmtStep __try_0 = fx_bootstrap_self_subset_parse_stmt(kinds, vals, lens, pos, nodes, stmts);") != 1) {
        return Ok(322);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_parse_block_rest(kinds, vals, lens, pos, step.nodes, step.stmts, start);") != 1) {
        return Ok(323);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_parse_block_rest(kinds, vals, lens, pos, nodes, stmts, start);") != 1) {
        return Ok(324);
    }
    if (str_contains(c_src, "} fx_bootstrap_self_subset_Result_ParseOut;\n") != 1) {
        return Ok(325);
    }
    if (str_contains(c_src, "    int32_t idx;\n    fx_Vec_Expr nodes;\n} fx_bootstrap_self_subset_ParseOut;\n") != 1) {
        return Ok(326);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_vec_Expr_push_val(core_Allocator* region, fx_Vec_Expr v, fx_bootstrap_self_subset_Expr val)") != 1) {
        return Ok(327);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut fx_bootstrap_self_subset_parse_expr(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes)") != 1) {
        return Ok(328);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_expr body_len=2") != 1) {
        return Ok(329);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut fx_bootstrap_self_subset_parse_factor(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes)") != 1) {
        return Ok(330);
    }
    if (str_contains(c_src, "fx_Vec_Expr nodes2 = fx_bootstrap_self_subset_vec_Expr_push_val(core_default_allocator(), nodes, (fx_bootstrap_self_subset_Expr){ .tag = FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_NUM, .u = { .num = v } });") != 1) {
        return Ok(331);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_RETURN, .u = { .return_ = parsed.idx } });") != 1) {
        return Ok(332);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut __try_0 = fx_bootstrap_self_subset_parse_expr(kinds, vals, lens, &mut_pos, nodes);") != 1) {
        return Ok(333);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_IDENT") != 1) {
        return Ok(334);
    }
    if (str_contains(c_src, "fx_Vec_Expr nodes2 = fx_bootstrap_self_subset_vec_Expr_push_val(core_default_allocator(), nodes, (fx_bootstrap_self_subset_Expr){ .tag = FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_IDENT, .u = { .ident = { .f0 = off, .f1 = ln } } });") != 1) {
        return Ok(335);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_LET, .u = { .let = { .f0 = name_off, .f1 = name_len, .f2 = parsed.idx } } });") != 1) {
        return Ok(336);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_ASSIGN, .u = { .assign = { .f0 = name_off, .f1 = name_len, .f2 = parsed.idx } } });") != 1) {
        return Ok(337);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), body_blk.stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_WHILE, .u = { .while_ = { .f0 = cond.idx, .f1 = body_start, .f2 = body_blk.count } } });") != 1) {
        return Ok(338);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_BlockParseOut __try_5 = fx_bootstrap_self_subset_parse_block(kinds, vals, lens, pos, cond.nodes, stmts);") != 1) {
        return Ok(339);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut __try_3 = fx_bootstrap_self_subset_parse_expr(kinds, vals, lens, &mut_pos, nodes);") != 1) {
        return Ok(340);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_CALL, .u = { .call = { .f0 = name_off, .f1 = name_len, .f2 = 0, .f3 = 0 } } });") != 1) {
        return Ok(341);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_CALL, .u = { .call = { .f0 = name_off, .f1 = name_len, .f2 = 1, .f3 = parsed.idx } } });") != 1) {
        return Ok(345);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), then_blk.stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_IF, .u = { .if_ = { .f0 = cond.idx, .f1 = then_start, .f2 = then_blk.count, .f3 = 0, .f4 = 0 } } });") != 1) {
        return Ok(342);
    }
    if (str_contains(c_src, "fx_Vec_Stmt stmts2 = fx_bootstrap_self_subset_vec_Stmt_push_val(core_default_allocator(), else_blk.stmts, (fx_bootstrap_self_subset_Stmt){ .tag = FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_IF, .u = { .if_ = { .f0 = cond.idx, .f1 = then_start, .f2 = then_blk.count, .f3 = else_start, .f4 = else_blk.count } } });") != 1) {
        return Ok(343);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_BlockParseOut __try_6 = fx_bootstrap_self_subset_parse_block(kinds, vals, lens, pos, then_blk.nodes, then_blk.stmts);") != 1) {
        return Ok(344);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_ADD") != 1) {
        return Ok(346);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut fx_bootstrap_self_subset_parse_term(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes)") != 1) {
        return Ok(347);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut fx_bootstrap_self_subset_parse_expr_tail(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, int32_t acc_idx, fx_Vec_Expr acc_nodes)") != 1) {
        return Ok(348);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_CALLEXPR") != 1) {
        return Ok(349);
    }
    if (str_contains(c_src, "fx_Vec_Expr nodes2 = fx_bootstrap_self_subset_vec_Expr_push_val(core_default_allocator(), nodes, (fx_bootstrap_self_subset_Expr){ .tag = FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_CALLEXPR, .u = { .callExpr = { .f0 = off, .f1 = ln } } })") != 1) {
        return Ok(350);
    }
    if (str_contains(c_src, "if ((kinds.data[(*pos)] == 6))") != 1) {
        return Ok(351);
    }
    if (str_contains(c_src, "fx_Vec_Expr nodes3 = fx_bootstrap_self_subset_vec_Expr_push_val(core_default_allocator(), parsed.nodes, (fx_bootstrap_self_subset_Expr){ .tag = FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_CALLEXPR, .u = { .callExpr = { .f0 = off, .f1 = ln } } })") != 1) {
        return Ok(355);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_STMT_TAG_REGION") != 1) {
        return Ok(352);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_ParseOut fx_bootstrap_self_subset_parse_cond(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, int32_t* pos, fx_Vec_Expr nodes)") != 1) {
        return Ok(353);
    }
    if (str_contains(c_src, "if ((k == 26))") != 1) {
        return Ok(354);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_CMPLT") != 1) {
        return Ok(356);
    }
    if (str_contains(c_src, "fx_Vec_Expr nodes2 = fx_bootstrap_self_subset_vec_Expr_push_val(core_default_allocator(), right.nodes, (fx_bootstrap_self_subset_Expr){ .tag = FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_CMPLT, .u = { .cmpLt = { .f0 = left.idx, .f1 = right.idx } } })") != 1) {
        return Ok(357);
    }
    if (str_contains(c_src, "if ((k == 15))") != 1) {
        return Ok(358);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_cond body_len=11") != 1) {
        return Ok(359);
    }

    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_EnumOut fx_bootstrap_self_subset_parse_enum_variants_rest(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos, fx_bootstrap_self_subset_ImpOut name, fx_bootstrap_self_subset_StrBuilder var_buf, fx_bootstrap_self_subset_StrBuilder payload_buf, int32_t variant_count)") != 1) {
        return Ok(247);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_enum_variants_rest body_len=25") != 1) {
        return Ok(248);
    }
    if (str_contains(c_src, "const char* variants_acc = fx_bootstrap_self_subset_strbuf_finish(var_buf);") != 1) {
        return Ok(249);
    }
    if (str_contains(c_src, ".variants_env = variants_acc, .payloads_env = payloads_acc") != 1) {
        return Ok(250);
    }
    if (str_contains(c_src, "fx_lib_sh_lexer_Result_string __try_0 = fx_lib_sh_lexer_slice_str(src, v_off, v_len);") != 1) {
        return Ok(256);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_string __try_1 = fx_bootstrap_self_subset_parse_enum_variant_payload_spec(kinds, vals, lens, src, pos, vname);") != 1) {
        return Ok(260);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_StrBuilder pushed2 = fx_bootstrap_self_subset_strbuf_push(pushed, \"|\");") != 1) {
        return Ok(257);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_parse_enum_variants_rest(kinds, vals, lens, src, pos, name, pushed2, payload_sep, (variant_count + 1));") != 1) {
        return Ok(251);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Result_EnumOut fx_bootstrap_self_subset_parse_enum_def(fx_Vec_i32 kinds, fx_Vec_i32 vals, fx_Vec_i32 lens, const char* src, int32_t* pos)") != 1) {
        return Ok(252);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_enum_def body_len=15") != 1) {
        return Ok(253);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_StrBuilder empty_buf = fx_bootstrap_self_subset_strbuf_new()") != 1) {
        return Ok(254);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_parse_enum_variants_rest(kinds, vals, lens, src, pos, name, empty_buf, empty_payload, 0);\n}\n\n/* fx bootstrap emit: bootstrap_self_subset_parse_effects_clause") != 1) {
        return Ok(255);
    }
    if (str_contains(c_src, "bootstrap_self_subset_parse_loader=load_src") != 1) {
        return Ok(152);
    }
    if (str_contains(c_src, "fx_bootstrap_self_subset_Expr") != 1) {
        return Ok(110);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_NUM") != 1) {
        return Ok(111);
    }
    if (str_contains(c_src, "FX_BOOTSTRAP_SELF_SUBSET_EXPR_TAG_STOP") != 1) {
        return Ok(114);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_self_subset_tag(fx_bootstrap_self_subset_Expr e)") != 1) {
        return Ok(115);
    }
    if (str_contains(c_src, "switch (_scrutinee.tag)") != 1) {
        return Ok(116);
    }
    if (str_contains(c_src, "int32_t n = _scrutinee.u.num") != 1) {
        return Ok(117);
    }
    if (str_contains(c_src, "int32_t fx_bootstrap_self_subset_main(void)") != 1) {
        return Ok(112);
    }
    if (str_contains(c_src, "return fx_bootstrap_self_subset_tag((fx_bootstrap_self_subset_Expr)") != 1) {
        return Ok(118);
    }
    return Ok(42);
}

fn fixture_ok_enum_payload_multi_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_multi()?;
    if (str_contains(c_src, "fx_ok_enum_payload_multi_ShapeTag") != 1) {
        return Ok(170);
    }
    if (str_contains(c_src, "FX_OK_ENUM_PAYLOAD_MULTI_SHAPE_TAG_POINT") != 1) {
        return Ok(171);
    }
    if (str_contains(c_src, "_scrutinee.u.point.f0") != 1) {
        return Ok(172);
    }
    if (str_contains(c_src, "_scrutinee.u.point.f1") != 1) {
        return Ok(173);
    }
    if (str_contains(c_src, ".point = { .f0 = 10, .f1 = 32 }") != 1) {
        return Ok(174);
    }
    if (str_contains(c_src, "int32_t fx_ok_enum_payload_multi_main(void)") != 1) {
        return Ok(175);
    }
    if (str_contains(c_src, "_match_result = (x + y)") != 1) {
        return Ok(176);
    }
    if (str_contains(c_src, "case FX_OK_ENUM_PAYLOAD_MULTI_SHAPE_TAG_UNIT") != 1) {
        return Ok(177);
    }
    return Ok(42);
}

fn fixture_ok_enum_payload_string_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_string()?;
    if (str_contains(c_src, "fx_ok_enum_payload_string_MsgTag") != 1) {
        return Ok(180);
    }
    if (str_contains(c_src, "FX_OK_ENUM_PAYLOAD_STRING_MSG_TAG_TEXT") != 1) {
        return Ok(181);
    }
    if (str_contains(c_src, "const char* text") != 1) {
        return Ok(182);
    }
    if (str_contains(c_src, "const char* s = _scrutinee.u.text") != 1) {
        return Ok(183);
    }
    if (str_contains(c_src, "fx_ok_enum_payload_string_noop(s)") != 1) {
        return Ok(184);
    }
    if (str_contains(c_src, ".text = \"hello\"") != 1) {
        return Ok(185);
    }
    if (str_contains(c_src, "int32_t fx_ok_enum_payload_string_main(void)") != 1) {
        return Ok(186);
    }
    if (str_contains(c_src, "case FX_OK_ENUM_PAYLOAD_STRING_MSG_TAG_NUM") != 1) {
        return Ok(187);
    }
    if (str_contains(c_src, "(void)_s") != 1) {
        return Ok(188);
    }
    return Ok(42);
}

fn fixture_ok_enum_payload_ignore_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.enum_payload_ignore_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_ignore()?;
    if (str_contains(c_src, "fx_ok_enum_payload_ignore_PairTag") != 1) {
        return Ok(268);
    }
    if (str_contains(c_src, "FX_OK_ENUM_PAYLOAD_IGNORE_PAIR_TAG_TWO") != 1) {
        return Ok(269);
    }
    if (str_contains(c_src, "switch (_scrutinee.tag)") != 1) {
        return Ok(270);
    }
    if (str_contains(c_src, "_scrutinee.u.two.f0") != 1) {
        return Ok(271);
    }
    if (str_contains(c_src, "int32_t fx_ok_enum_payload_ignore_first") != 1) {
        return Ok(272);
    }
    if (str_contains(c_src, "int32_t fx_ok_enum_payload_ignore_main(void)") != 1) {
        return Ok(273);
    }
    if (str_contains(c_src, ".f0 = 42, .f1 = 99") != 1) {
        return Ok(274);
    }
    return Ok(42);
}

fn fixture_ok_result_guard_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.result_guard_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_result_guard()?;
    if (str_contains(c_src, "fx_ok_result_guard_Result_i32") != 1) {
        return Ok(275);
    }
    if (str_contains(c_src, "FX_RESULT_TAG_ERR") != 1) {
        return Ok(276);
    }
    if (str_contains(c_src, "fx_ok_result_guard_parse_positive") != 1) {
        return Ok(277);
    }
    if (str_contains(c_src, "__try_0") != 1) {
        return Ok(278);
    }
    if (str_contains(c_src, "fx_ok_result_guard_main(void)") != 1) {
        return Ok(279);
    }
    if (str_contains(c_src, "zspec/core.h") != 1) {
        return Ok(280);
    }
    return Ok(42);
}

fn fixture_ok_using_core_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.using_core_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_using_core()?;
    if (str_contains(c_src, "fx_ok_using_core_Result_i32") != 1) {
        return Ok(281);
    }
    if (str_contains(c_src, "fx_ok_using_core_step1(void)") != 1) {
        return Ok(282);
    }
    if (str_contains(c_src, "fx_ok_using_core_step2(int32_t n)") != 1) {
        return Ok(283);
    }
    if (str_contains(c_src, "__try_0") != 1) {
        return Ok(284);
    }
    if (str_contains(c_src, "__try_1") != 1) {
        return Ok(285);
    }
    if (str_contains(c_src, "fx_ok_using_core_step2(a)") != 1) {
        return Ok(286);
    }
    if (str_contains(c_src, ".ok_val = b") != 1) {
        return Ok(287);
    }
    return Ok(42);
}

fn fixture_ok_using_core_mem_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.using_core_mem_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_using_core_mem()?;
    if (str_contains(c_src, "fx_ok_using_core_mem_Result_i32") != 1) {
        return Ok(288);
    }
    if (str_contains(c_src, "fx_ok_using_core_mem_step1(void)") != 1) {
        return Ok(289);
    }
    if (str_contains(c_src, "fx_ok_using_core_mem_step2(int32_t n)") != 1) {
        return Ok(290);
    }
    if (str_contains(c_src, "__try_0") != 1) {
        return Ok(291);
    }
    if (str_contains(c_src, "__try_1") != 1) {
        return Ok(292);
    }
    if (str_contains(c_src, "fx_ok_using_core_mem_step2(a)") != 1) {
        return Ok(293);
    }
    if (str_contains(c_src, ".ok_val = b") != 1) {
        return Ok(294);
    }
    return Ok(42);
}

fn fixture_ok_using_core_io_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.using_core_io_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_using_core_io()?;
    if (str_contains(c_src, "fx_ok_using_core_io_Result_i32") != 1) {
        return Ok(295);
    }
    if (str_contains(c_src, "fx_ok_using_core_io_step1(void)") != 1) {
        return Ok(296);
    }
    if (str_contains(c_src, "fx_ok_using_core_io_step2(int32_t n)") != 1) {
        return Ok(297);
    }
    if (str_contains(c_src, "__try_0") != 1) {
        return Ok(298);
    }
    if (str_contains(c_src, "__try_1") != 1) {
        return Ok(299);
    }
    if (str_contains(c_src, "fx_ok_using_core_io_step2(a)") != 1) {
        return Ok(300);
    }
    if (str_contains(c_src, ".ok_val = b") != 1) {
        return Ok(301);
    }
    return Ok(42);
}

fn fixture_ok_using_core_string_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let stage: i32 = sh_parse.using_core_string_parse_tests()?;
    if (stage != 42) {
        return Ok(stage);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_using_core_string()?;
    if (str_contains(c_src, "fx_ok_using_core_string_Result_i32") != 1) {
        return Ok(302);
    }
    if (str_contains(c_src, "fx_ok_using_core_string_step1(void)") != 1) {
        return Ok(303);
    }
    if (str_contains(c_src, "fx_ok_using_core_string_step2(int32_t n)") != 1) {
        return Ok(304);
    }
    if (str_contains(c_src, "__try_0") != 1) {
        return Ok(305);
    }
    if (str_contains(c_src, "__try_1") != 1) {
        return Ok(306);
    }
    if (str_contains(c_src, "fx_ok_using_core_string_step2(a)") != 1) {
        return Ok(307);
    }
    if (str_contains(c_src, ".ok_val = b") != 1) {
        return Ok(308);
    }
    return Ok(42);
}

fn fixture_ok_enum_payload_mixed_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_mixed()?;
    if (str_contains(c_src, "fx_ok_enum_payload_mixed_EventTag") != 1) {
        return Ok(190);
    }
    if (str_contains(c_src, "FX_OK_ENUM_PAYLOAD_MIXED_EVENT_TAG_TEXT") != 1) {
        return Ok(191);
    }
    if (str_contains(c_src, "FX_OK_ENUM_PAYLOAD_MIXED_EVENT_TAG_POINT") != 1) {
        return Ok(192);
    }
    if (str_contains(c_src, "const char* text") != 1) {
        return Ok(193);
    }
    if (str_contains(c_src, "_scrutinee.u.point.f0") != 1) {
        return Ok(194);
    }
    if (str_contains(c_src, "fx_ok_enum_payload_mixed_noop(s)") != 1) {
        return Ok(195);
    }
    if (str_contains(c_src, ".point = { .f0 = 10, .f1 = 32 }") != 1) {
        return Ok(196);
    }
    if (str_contains(c_src, "int32_t fx_ok_enum_payload_mixed_main(void)") != 1) {
        return Ok(197);
    }
    if (str_contains(c_src, "_match_result = (x + y)") != 1) {
        return Ok(198);
    }
    if (str_contains(c_src, "case FX_OK_ENUM_PAYLOAD_MIXED_EVENT_TAG_STOP") != 1) {
        return Ok(199);
    }
    return Ok(42);
}

fn fixture_ok_vec_enum_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_vec_enum()?;
    if (str_contains(c_src, "fx_ok_vec_enum_TokTag") != 1) {
        return Ok(200);
    }
    if (str_contains(c_src, "fx_Vec_Tok") != 1) {
        return Ok(201);
    }
    if (str_contains(c_src, "vec_Tok_arena_new") != 1) {
        return Ok(202);
    }
    if (str_contains(c_src, "v.data[0]") != 1) {
        return Ok(203);
    }
    if (str_contains(c_src, "vec_Tok_push_val") != 1) {
        return Ok(204);
    }
    if (str_contains(c_src, "core_arena_new") != 1) {
        return Ok(205);
    }
    if (str_contains(c_src, "int32_t fx_ok_vec_enum_main(void)") != 1) {
        return Ok(206);
    }
    if (str_contains(c_src, "core_mem_reset") != 1) {
        return Ok(207);
    }
    if (str_contains(c_src, "core_mem_reset(r)") != 1) {
        return Ok(210);
    }
    if (str_contains(c_src, "_scrutinee.u.num") != 1) {
        return Ok(208);
    }
    if (str_contains(c_src, "return fx_ok_vec_enum_build();") != 1) {
        return Ok(209);
    }
    return Ok(42);
}

fn fixture_ok_mut_slice_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_mut_slice()?;
    if (str_contains(c_src, "fx_MutSlice_i32") != 1) {
        return Ok(230);
    }
    if (str_contains(c_src, "fx_ok_mut_slice_Array_i32_3") != 1) {
        return Ok(231);
    }
    if (str_contains(c_src, "int32_t fx_ok_mut_slice_bump(fx_MutSlice_i32 s)") != 1) {
        return Ok(232);
    }
    if (str_contains(c_src, "s.data[0] = (s.data[0] + 1)") != 1) {
        return Ok(233);
    }
    if (str_contains(c_src, "view.data[1] = 9") != 1) {
        return Ok(234);
    }
    if (str_contains(c_src, "int32_t fx_ok_mut_slice_main(void)") != 1) {
        return Ok(235);
    }
    if (str_contains(c_src, "return ((view.data[0] + view.data[1]) + view.data[2])") != 1) {
        return Ok(236);
    }
    return Ok(42);
}

fn fixture_ok_while_zero_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_while_zero()?;
    if (str_contains(c_src, "int32_t fx_ok_while_zero_main(void)") != 1) {
        return Ok(211);
    }
    if (str_contains(c_src, "while (0)") != 1) {
        return Ok(212);
    }
    if (str_contains(c_src, "return 42") != 1) {
        return Ok(213);
    }
    if (str_contains(c_src, "return 0") != 1) {
        return Ok(214);
    }
    if (str_contains(c_src, "ok_while_zero body_len=3") != 1) {
        return Ok(215);
    }
    return Ok(42);
}

fn fixture_ok_if_else_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_if_else()?;
    if (str_contains(c_src, "int32_t fx_ok_if_else_pick(int32_t b)") != 1) {
        return Ok(216);
    }
    if (str_contains(c_src, "int32_t fx_ok_if_else_main(void)") != 1) {
        return Ok(217);
    }
    if (str_contains(c_src, "if (b)") != 1) {
        return Ok(218);
    }
    if (str_contains(c_src, "return fx_ok_if_else_pick(1)") != 1) {
        return Ok(219);
    }
    if (str_contains(c_src, "ok_if_else body_len=3") != 1) {
        return Ok(220);
    }
    return Ok(42);
}

fn fixture_ok_break_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_break()?;
    if (str_contains(c_src, "int32_t fx_ok_break_main(void)") != 1) {
        return Ok(221);
    }
    if (str_contains(c_src, "while (1)") != 1) {
        return Ok(222);
    }
    if (str_contains(c_src, "n == 3") != 1) {
        return Ok(223);
    }
    if (str_contains(c_src, "break;") != 1) {
        return Ok(224);
    }
    if (str_contains(c_src, "ok_break body_len=6") != 1) {
        return Ok(225);
    }
    return Ok(42);
}

fn fixture_ok_for_sum_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_for_sum()?;
    if (str_contains(c_src, "int32_t fx_ok_for_sum_main(void)") != 1) {
        return Ok(226);
    }
    if (str_contains(c_src, "for (int32_t i = 0; (i < 5); i = (i + 1))") != 1) {
        return Ok(227);
    }
    if (str_contains(c_src, "sum = (sum + i)") != 1) {
        return Ok(228);
    }
    if (str_contains(c_src, "return sum") != 1) {
        return Ok(229);
    }
    if (str_contains(c_src, "ok_for_sum body_len=6") != 1) {
        return Ok(230);
    }
    return Ok(42);
}

fn fixture_ok_continue_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_continue()?;
    if (str_contains(c_src, "int32_t fx_ok_continue_main(void)") != 1) {
        return Ok(231);
    }
    if (str_contains(c_src, "for (int32_t i = 0; (i < 5); i = (i + 1))") != 1) {
        return Ok(232);
    }
    if (str_contains(c_src, "if ((i == 2))") != 1) {
        return Ok(233);
    }
    if (str_contains(c_src, "continue;") != 1) {
        return Ok(234);
    }
    if (str_contains(c_src, "sum = (sum + i)") != 1) {
        return Ok(235);
    }
    if (str_contains(c_src, "return sum") != 1) {
        return Ok(236);
    }
    if (str_contains(c_src, "ok_continue body_len=8") != 1) {
        return Ok(237);
    }
    return Ok(42);
}

fn fixture_ok_cmp_lt_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_cmp_lt()?;
    if (str_contains(c_src, "int32_t fx_ok_cmp_lt_lt(int32_t a, int32_t b)") != 1) {
        return Ok(238);
    }
    if (str_contains(c_src, "return (a < b)") != 1) {
        return Ok(239);
    }
    if (str_contains(c_src, "int32_t fx_ok_cmp_lt_main(void)") != 1) {
        return Ok(240);
    }
    if (str_contains(c_src, "if (fx_ok_cmp_lt_lt(1, 2))") != 1) {
        return Ok(241);
    }
    if (str_contains(c_src, "return 10") != 1) {
        return Ok(242);
    }
    if (str_contains(c_src, "ok_cmp_lt body_len=1") != 1) {
        return Ok(243);
    }
    if (str_contains(c_src, "ok_cmp_lt_main body_len=3") != 1) {
        return Ok(244);
    }
    return Ok(42);
}

fn fixture_ok_effect_pure_call_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_effect_pure_call()?;
    if (str_contains(c_src, "int32_t fx_ok_effect_pure_call_add(int32_t a, int32_t b)") != 1) {
        return Ok(245);
    }
    if (str_contains(c_src, "return (a + b)") != 1) {
        return Ok(246);
    }
    if (str_contains(c_src, "int32_t fx_ok_effect_pure_call_main(void)") != 1) {
        return Ok(247);
    }
    if (str_contains(c_src, "return fx_ok_effect_pure_call_add(3, 4)") != 1) {
        return Ok(248);
    }
    if (str_contains(c_src, "ok_effect_pure_call body_len=1") != 1) {
        return Ok(249);
    }
    if (str_contains(c_src, "ok_effect_pure_call_main body_len=1") != 1) {
        return Ok(250);
    }
    return Ok(42);
}

fn fixture_ok_effect_io_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_effect_io()?;
    if (str_contains(c_src, "#include <stdio.h>") != 1) {
        return Ok(251);
    }
    if (str_contains(c_src, "int32_t fx_ok_effect_io_log_line(const char* msg)") != 1) {
        return Ok(252);
    }
    if (str_contains(c_src, "return puts(msg)") != 1) {
        return Ok(253);
    }
    if (str_contains(c_src, "int32_t fx_ok_effect_io_main(void)") != 1) {
        return Ok(254);
    }
    if (str_contains(c_src, "fx_ok_effect_io_log_line") != 1) {
        return Ok(255);
    }
    if (str_contains(c_src, "fx-io") != 1) {
        return Ok(256);
    }
    if (str_contains(c_src, "ok_effect_io body_len=1") != 1) {
        return Ok(257);
    }
    if (str_contains(c_src, "ok_effect_io_main body_len=1") != 1) {
        return Ok(258);
    }
    return Ok(42);
}

fn fixture_ok_extern_call_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_extern_call()?;
    if (str_contains(c_src, "int32_t my_add(int32_t a, int32_t b)") != 1) {
        return Ok(259);
    }
    if (str_contains(c_src, "int32_t fx_ok_extern_call_main(void)") != 1) {
        return Ok(260);
    }
    if (str_contains(c_src, "return my_add(10, 32)") != 1) {
        return Ok(261);
    }
    if (str_contains(c_src, "ok_extern_call body_len=1") != 1) {
        return Ok(262);
    }
    return Ok(42);
}

fn fixture_ok_char_lit_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_char_lit()?;
    if (str_contains(c_src, "int32_t fx_ok_char_lit_codes(void)") != 1) {
        return Ok(263);
    }
    if (str_contains(c_src, "int32_t a = 65") != 1) {
        return Ok(264);
    }
    if (str_contains(c_src, "int32_t nl = 10") != 1) {
        return Ok(265);
    }
    if (str_contains(c_src, "int32_t back = 92") != 1) {
        return Ok(266);
    }
    if (str_contains(c_src, "ok_char_lit body_len=7") != 1) {
        return Ok(267);
    }
    return Ok(42);
}

fn emit_fixture_tests() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let tc_ok: i32 = sh_parse.typecheck_fixture_tests()?;
    if (tc_ok != 42) {
        return Ok(tc_ok);
    }
    let main_ok: i32 = fixture_ok_main_tests()?;
    if (main_ok != 42) {
        return Ok(main_ok);
    }
    let add_ok: i32 = fixture_ok_add_tests()?;
    if (add_ok != 42) {
        return Ok(add_ok);
    }
    let lex_smoke_ok: i32 = fixture_bootstrap_lexer_smoke_tests()?;
    if (lex_smoke_ok != 42) {
        return Ok(lex_smoke_ok);
    }
    let real_lex_ok: i32 = fixture_bootstrap_real_lexer_radius_tests()?;
    if (real_lex_ok != 42) {
        return Ok(real_lex_ok);
    }
    let real_lex_full_ok: i32 = fixture_bootstrap_real_lexer_full_tests()?;
    let real_parse_radius_ok: i32 = fixture_bootstrap_real_parse_radius_tests()?;
    if (real_parse_radius_ok != 42) {
        return Ok(real_parse_radius_ok);
    }
    let real_parse_recursive_ok: i32 = fixture_bootstrap_real_parse_recursive_tests()?;
    if (real_parse_recursive_ok != 42) {
        return Ok(real_parse_recursive_ok);
    }
    let real_parse_expr_stmt_ok: i32 = fixture_bootstrap_real_parse_expr_stmt_tests()?;
    if (real_parse_expr_stmt_ok != 42) {
        return Ok(real_parse_expr_stmt_ok);
    }
    let real_parse_fn_def_ok: i32 = fixture_bootstrap_real_parse_fn_def_tests()?;
    if (real_parse_fn_def_ok != 42) {
        return Ok(real_parse_fn_def_ok);
    }
    let real_emit_radius_ok: i32 = fixture_bootstrap_real_emit_radius_tests()?;
    if (real_emit_radius_ok != 42) {
        return Ok(real_emit_radius_ok);
    }
    let real_emit_module_ok: i32 = fixture_bootstrap_real_emit_module_tests()?;
    if (real_emit_module_ok != 42) {
        return Ok(real_emit_module_ok);
    }
    if (real_lex_full_ok != 42) {
        return Ok(real_lex_full_ok);
    }
    let parse_smoke_ok: i32 = fixture_bootstrap_parse_smoke_tests()?;
    if (parse_smoke_ok != 42) {
        return Ok(parse_smoke_ok);
    }
    let emit_smoke_ok: i32 = fixture_bootstrap_emit_smoke_tests()?;
    if (emit_smoke_ok != 42) {
        return Ok(emit_smoke_ok);
    }
    let hello_ok: i32 = fixture_ok_hello_tests()?;
    if (hello_ok != 42) {
        return Ok(hello_ok);
    }
    let import_ok: i32 = fixture_ok_import_tests()?;
    if (import_ok != 42) {
        return Ok(import_ok);
    }
    let struct_ok: i32 = fixture_ok_struct_field_tests()?;
    if (struct_ok != 42) {
        return Ok(struct_ok);
    }
    let struct_ret_ok: i32 = fixture_ok_struct_return_tests()?;
    if (struct_ret_ok != 42) {
        return Ok(struct_ret_ok);
    }
    let color_ok: i32 = fixture_ok_color_match_tests()?;
    if (color_ok != 42) {
        return Ok(color_ok);
    }
    let band_ok: i32 = fixture_ok_band_match_tests()?;
    if (band_ok != 42) {
        return Ok(band_ok);
    }
    let enum_payload_ok: i32 = fixture_ok_enum_payload_tests()?;
    if (enum_payload_ok != 42) {
        return Ok(enum_payload_ok);
    }
    let enum_multi_ok: i32 = fixture_ok_enum_payload_multi_tests()?;
    if (enum_multi_ok != 42) {
        return Ok(enum_multi_ok);
    }
    let enum_str_ok: i32 = fixture_ok_enum_payload_string_tests()?;
    if (enum_str_ok != 42) {
        return Ok(enum_str_ok);
    }
    let enum_mix_ok: i32 = fixture_ok_enum_payload_mixed_tests()?;
    if (enum_mix_ok != 42) {
        return Ok(enum_mix_ok);
    }
    let enum_ignore_ok: i32 = fixture_ok_enum_payload_ignore_tests()?;
    if (enum_ignore_ok != 42) {
        return Ok(enum_ignore_ok);
    }
    let result_guard_ok: i32 = fixture_ok_result_guard_tests()?;
    if (result_guard_ok != 42) {
        return Ok(result_guard_ok);
    }
    let using_core_ok: i32 = fixture_ok_using_core_tests()?;
    if (using_core_ok != 42) {
        return Ok(using_core_ok);
    }
    let using_core_mem_ok: i32 = fixture_ok_using_core_mem_tests()?;
    if (using_core_mem_ok != 42) {
        return Ok(using_core_mem_ok);
    }
    let using_core_io_ok: i32 = fixture_ok_using_core_io_tests()?;
    if (using_core_io_ok != 42) {
        return Ok(using_core_io_ok);
    }
    let using_core_string_ok: i32 = fixture_ok_using_core_string_tests()?;
    if (using_core_string_ok != 42) {
        return Ok(using_core_string_ok);
    }
    let vec_enum_ok: i32 = fixture_ok_vec_enum_tests()?;
    if (vec_enum_ok != 42) {
        return Ok(vec_enum_ok);
    }
    let mut_slice_ok: i32 = fixture_ok_mut_slice_tests()?;
    if (mut_slice_ok != 42) {
        return Ok(mut_slice_ok);
    }
    let while_zero_ok: i32 = fixture_ok_while_zero_tests()?;
    if (while_zero_ok != 42) {
        return Ok(while_zero_ok);
    }
    let if_else_ok: i32 = fixture_ok_if_else_tests()?;
    if (if_else_ok != 42) {
        return Ok(if_else_ok);
    }
    let break_ok: i32 = fixture_ok_break_tests()?;
    if (break_ok != 42) {
        return Ok(break_ok);
    }
    let for_sum_ok: i32 = fixture_ok_for_sum_tests()?;
    if (for_sum_ok != 42) {
        return Ok(for_sum_ok);
    }
    let continue_ok: i32 = fixture_ok_continue_tests()?;
    if (continue_ok != 42) {
        return Ok(continue_ok);
    }
    let cmp_lt_ok: i32 = fixture_ok_cmp_lt_tests()?;
    if (cmp_lt_ok != 42) {
        return Ok(cmp_lt_ok);
    }
    let pure_call_ok: i32 = fixture_ok_effect_pure_call_tests()?;
    if (pure_call_ok != 42) {
        return Ok(pure_call_ok);
    }
    let effect_io_ok: i32 = fixture_ok_effect_io_tests()?;
    if (effect_io_ok != 42) {
        return Ok(effect_io_ok);
    }
    let extern_call_ok: i32 = fixture_ok_extern_call_tests()?;
    if (extern_call_ok != 42) {
        return Ok(extern_call_ok);
    }
    let char_lit_ok: i32 = fixture_ok_char_lit_tests()?;
    if (char_lit_ok != 42) {
        return Ok(char_lit_ok);
    }
    let inc: i32 = sh_parse.mod_includes_parsed_tests()?;
    if (inc != 42) {
        return Ok(inc);
    }
    return fixture_bootstrap_self_subset_tests();
}

fn roundtrip_write_simple_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_simple_main_template()?;
    let written: i32 = fs_write_text("bootstrap_simple_main.c.in", c_src);
    if (written != 0) {
        return Ok(130);
    }
    return Ok(42);
}

fn roundtrip_write_add_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_add_main_template()?;
    let written: i32 = fs_write_text("bootstrap_add_main.c.in", c_src);
    if (written != 0) {
        return Ok(131);
    }
    return Ok(42);
}

fn roundtrip_write_hello_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_hello_main_template()?;
    let written: i32 = fs_write_text("bootstrap_hello_main.c.in", c_src);
    if (written != 0) {
        return Ok(132);
    }
    return Ok(42);
}

fn roundtrip_write_module_add_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_module_add_template()?;
    let written: i32 = fs_write_text("bootstrap_module_add.c.in", c_src);
    if (written != 0) {
        return Ok(133);
    }
    return Ok(42);
}

fn roundtrip_write_import_add_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_import_add_main_template()?;
    let written: i32 = fs_write_text("bootstrap_import_add_main.c.in", c_src);
    if (written != 0) {
        return Ok(134);
    }
    return Ok(42);
}

fn roundtrip_write_struct_field_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_struct_field_main_template()?;
    let written: i32 = fs_write_text("bootstrap_struct_field_main.c.in", c_src);
    if (written != 0) {
        return Ok(135);
    }
    return Ok(42);
}

fn roundtrip_write_struct_return_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_struct_return_main_template()?;
    let written: i32 = fs_write_text("bootstrap_struct_return_main.c.in", c_src);
    if (written != 0) {
        return Ok(136);
    }
    return Ok(42);
}

fn roundtrip_write_color_match_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_color_match_main_template()?;
    let written: i32 = fs_write_text("bootstrap_color_match_main.c.in", c_src);
    if (written != 0) {
        return Ok(137);
    }
    return Ok(42);
}

fn roundtrip_write_band_match_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_band_match_main_template()?;
    let written: i32 = fs_write_text("bootstrap_band_match_main.c.in", c_src);
    if (written != 0) {
        return Ok(138);
    }
    return Ok(42);
}

fn roundtrip_write_nested_match_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_nested_match_main_template()?;
    let written: i32 = fs_write_text("bootstrap_nested_match_main.c.in", c_src);
    if (written != 0) {
        return Ok(162);
    }
    return Ok(42);
}

fn roundtrip_write_enum_payload_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_enum_payload_main_template()?;
    let written: i32 = fs_write_text("bootstrap_enum_payload_main.c.in", c_src);
    if (written != 0) {
        return Ok(139);
    }
    return Ok(42);
}

fn roundtrip_write_enum_payload_multi_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_enum_payload_multi_main_template()?;
    let written: i32 = fs_write_text("bootstrap_enum_payload_multi_main.c.in", c_src);
    if (written != 0) {
        return Ok(140);
    }
    return Ok(42);
}

fn roundtrip_write_enum_payload_string_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_enum_payload_string_main_template()?;
    let written: i32 = fs_write_text("bootstrap_enum_payload_string_main.c.in", c_src);
    if (written != 0) {
        return Ok(141);
    }
    return Ok(42);
}

fn roundtrip_write_enum_payload_mixed_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_enum_payload_mixed_main_template()?;
    let written: i32 = fs_write_text("bootstrap_enum_payload_mixed_main.c.in", c_src);
    if (written != 0) {
        return Ok(142);
    }
    return Ok(42);
}

fn roundtrip_write_vec_enum_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_vec_enum_main_template()?;
    let written: i32 = fs_write_text("bootstrap_vec_enum_main.c.in", c_src);
    if (written != 0) {
        return Ok(143);
    }
    return Ok(42);
}

fn roundtrip_write_while_zero_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_while_zero_main_template()?;
    let written: i32 = fs_write_text("bootstrap_while_zero_main.c.in", c_src);
    if (written != 0) {
        return Ok(144);
    }
    return Ok(42);
}

fn roundtrip_write_if_else_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_if_else_main_template()?;
    let written: i32 = fs_write_text("bootstrap_if_else_main.c.in", c_src);
    if (written != 0) {
        return Ok(145);
    }
    return Ok(42);
}

fn roundtrip_write_break_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_break_main_template()?;
    let written: i32 = fs_write_text("bootstrap_break_main.c.in", c_src);
    if (written != 0) {
        return Ok(146);
    }
    return Ok(42);
}

fn roundtrip_write_for_sum_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_for_sum_main_template()?;
    let written: i32 = fs_write_text("bootstrap_for_sum_main.c.in", c_src);
    if (written != 0) {
        return Ok(147);
    }
    return Ok(42);
}

fn roundtrip_write_continue_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_continue_main_template()?;
    let written: i32 = fs_write_text("bootstrap_continue_main.c.in", c_src);
    if (written != 0) {
        return Ok(148);
    }
    return Ok(42);
}

fn roundtrip_write_cmp_lt_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_cmp_lt_main_template()?;
    let written: i32 = fs_write_text("bootstrap_cmp_lt_main.c.in", c_src);
    if (written != 0) {
        return Ok(149);
    }
    return Ok(42);
}

fn roundtrip_write_pure_call_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_pure_call_main_template()?;
    let written: i32 = fs_write_text("bootstrap_pure_call_main.c.in", c_src);
    if (written != 0) {
        return Ok(150);
    }
    return Ok(42);
}

fn roundtrip_write_effect_io_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_effect_io_main_template()?;
    let written: i32 = fs_write_text("bootstrap_effect_io_main.c.in", c_src);
    if (written != 0) {
        return Ok(151);
    }
    return Ok(42);
}

fn roundtrip_write_extern_call_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_extern_call_main_template()?;
    let written: i32 = fs_write_text("bootstrap_extern_call_main.c.in", c_src);
    if (written != 0) {
        return Ok(152);
    }
    return Ok(42);
}

fn roundtrip_write_char_lit_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_char_lit_main_template()?;
    let written: i32 = fs_write_text("bootstrap_char_lit_main.c.in", c_src);
    if (written != 0) {
        return Ok(153);
    }
    return Ok(42);
}

fn roundtrip_write_enum_payload_ignore_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_enum_payload_ignore_main_template()?;
    let written: i32 = fs_write_text("bootstrap_enum_payload_ignore_main.c.in", c_src);
    if (written != 0) {
        return Ok(154);
    }
    return Ok(42);
}

fn roundtrip_write_result_guard_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_result_guard_main_template()?;
    let written: i32 = fs_write_text("bootstrap_result_guard_main.c.in", c_src);
    if (written != 0) {
        return Ok(155);
    }
    return Ok(42);
}

fn roundtrip_write_using_core_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_using_core_main_template()?;
    let written: i32 = fs_write_text("bootstrap_using_core_main.c.in", c_src);
    if (written != 0) {
        return Ok(156);
    }
    return Ok(42);
}

fn roundtrip_write_struct_field_assign_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_struct_field_assign_main_template()?;
    let written: i32 = fs_write_text("bootstrap_struct_field_assign_main.c.in", c_src);
    if (written != 0) {
        return Ok(157);
    }
    return Ok(42);
}

fn roundtrip_write_defer_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_defer_main_template()?;
    let written: i32 = fs_write_text("bootstrap_defer_main.c.in", c_src);
    if (written != 0) {
        return Ok(158);
    }
    return Ok(42);
}

fn roundtrip_write_struct_own_move_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_struct_own_move_main_template()?;
    let written: i32 = fs_write_text("bootstrap_struct_own_move_main.c.in", c_src);
    if (written != 0) {
        return Ok(159);
    }
    return Ok(42);
}

fn roundtrip_write_struct_mut_field_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_struct_mut_field_main_template()?;
    let written: i32 = fs_write_text("bootstrap_struct_mut_field_main.c.in", c_src);
    if (written != 0) {
        return Ok(160);
    }
    return Ok(42);
}

fn roundtrip_write_struct_shared_field_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_struct_shared_field_main_template()?;
    let written: i32 = fs_write_text("bootstrap_struct_shared_field_main.c.in", c_src);
    if (written != 0) {
        return Ok(161);
    }
    return Ok(42);
}

fn roundtrip_write_borrow_mut_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_borrow_mut_main_template()?;
    let written: i32 = fs_write_text("bootstrap_borrow_mut_main.c.in", c_src);
    if (written != 0) {
        return Ok(163);
    }
    return Ok(42);
}

fn roundtrip_write_own_i32_move_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_own_i32_move_main_template()?;
    let written: i32 = fs_write_text("bootstrap_own_i32_move_main.c.in", c_src);
    if (written != 0) {
        return Ok(164);
    }
    return Ok(42);
}

fn roundtrip_write_deref_assign_mut_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deref_assign_mut_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deref_assign_mut_main.c.in", c_src);
    if (written != 0) {
        return Ok(165);
    }
    return Ok(42);
}

fn roundtrip_write_neg_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_neg_main_template()?;
    let written: i32 = fs_write_text("bootstrap_neg_main.c.in", c_src);
    if (written != 0) {
        return Ok(166);
    }
    return Ok(42);
}

fn roundtrip_write_logic_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_logic_main_template()?;
    let written: i32 = fs_write_text("bootstrap_logic_main.c.in", c_src);
    if (written != 0) {
        return Ok(167);
    }
    return Ok(42);
}

fn roundtrip_write_bitshift_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_bitshift_main_template()?;
    let written: i32 = fs_write_text("bootstrap_bitshift_main.c.in", c_src);
    if (written != 0) {
        return Ok(168);
    }
    return Ok(42);
}

fn roundtrip_write_bits_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_bits_main_template()?;
    let written: i32 = fs_write_text("bootstrap_bits_main.c.in", c_src);
    if (written != 0) {
        return Ok(169);
    }
    return Ok(42);
}

fn roundtrip_write_modulo_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_modulo_main_template()?;
    let written: i32 = fs_write_text("bootstrap_modulo_main.c.in", c_src);
    if (written != 0) {
        return Ok(170);
    }
    return Ok(42);
}

fn roundtrip_write_cast_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_cast_main_template()?;
    let written: i32 = fs_write_text("bootstrap_cast_main.c.in", c_src);
    if (written != 0) {
        return Ok(171);
    }
    return Ok(42);
}

fn roundtrip_write_unsigned_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_unsigned_main_template()?;
    let written: i32 = fs_write_text("bootstrap_unsigned_main.c.in", c_src);
    if (written != 0) {
        return Ok(172);
    }
    return Ok(42);
}

fn roundtrip_write_guard_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_guard_main_template()?;
    let written: i32 = fs_write_text("bootstrap_guard_main.c.in", c_src);
    if (written != 0) {
        return Ok(173);
    }
    return Ok(42);
}

fn roundtrip_write_array_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_array_main_template()?;
    let written: i32 = fs_write_text("bootstrap_array_main.c.in", c_src);
    if (written != 0) {
        return Ok(174);
    }
    return Ok(42);
}

fn roundtrip_write_slice_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_slice_main_template()?;
    let written: i32 = fs_write_text("bootstrap_slice_main.c.in", c_src);
    if (written != 0) {
        return Ok(175);
    }
    return Ok(42);
}

fn roundtrip_write_scoperel_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_scoperel_main_template()?;
    let written: i32 = fs_write_text("bootstrap_scoperel_main.c.in", c_src);
    if (written != 0) {
        return Ok(176);
    }
    return Ok(42);
}

fn roundtrip_write_scopederef_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_scopederef_main_template()?;
    let written: i32 = fs_write_text("bootstrap_scopederef_main.c.in", c_src);
    if (written != 0) {
        return Ok(177);
    }
    return Ok(42);
}

fn roundtrip_write_regif_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regif_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regif_main.c.in", c_src);
    if (written != 0) {
        return Ok(178);
    }
    return Ok(42);
}

fn roundtrip_write_regwhile_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regwhile_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regwhile_main.c.in", c_src);
    if (written != 0) {
        return Ok(179);
    }
    return Ok(42);
}

fn roundtrip_write_regifelse_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regifelse_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regifelse_main.c.in", c_src);
    if (written != 0) {
        return Ok(180);
    }
    return Ok(42);
}

fn roundtrip_write_regfor_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regfor_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regfor_main.c.in", c_src);
    if (written != 0) {
        return Ok(181);
    }
    return Ok(42);
}

fn roundtrip_write_regmatch_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regmatch_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regmatch_main.c.in", c_src);
    if (written != 0) {
        return Ok(182);
    }
    return Ok(42);
}

fn roundtrip_write_regparam_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regparam_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regparam_main.c.in", c_src);
    if (written != 0) {
        return Ok(183);
    }
    return Ok(42);
}

fn roundtrip_write_regparamnest_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regparamnest_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regparamnest_main.c.in", c_src);
    if (written != 0) {
        return Ok(184);
    }
    return Ok(42);
}

fn roundtrip_write_regparamvec_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_regparamvec_main_template()?;
    let written: i32 = fs_write_text("bootstrap_regparamvec_main.c.in", c_src);
    if (written != 0) {
        return Ok(185);
    }
    return Ok(42);
}

fn roundtrip_write_vecdefer_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_vecdefer_main_template()?;
    let written: i32 = fs_write_text("bootstrap_vecdefer_main.c.in", c_src);
    if (written != 0) {
        return Ok(186);
    }
    return Ok(42);
}

fn roundtrip_write_fxnested_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_fxnested_main_template()?;
    let written: i32 = fs_write_text("bootstrap_fxnested_main.c.in", c_src);
    if (written != 0) {
        return Ok(187);
    }
    return Ok(42);
}

fn roundtrip_write_fxtriple_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_fxtriple_main_template()?;
    let written: i32 = fs_write_text("bootstrap_fxtriple_main.c.in", c_src);
    if (written != 0) {
        return Ok(188);
    }
    return Ok(42);
}

fn roundtrip_write_tripletry_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_tripletry_main_template()?;
    let written: i32 = fs_write_text("bootstrap_tripletry_main.c.in", c_src);
    if (written != 0) {
        return Ok(189);
    }
    return Ok(42);
}

fn roundtrip_write_tripletryok_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_tripletryok_main_template()?;
    let written: i32 = fs_write_text("bootstrap_tripletryok_main.c.in", c_src);
    if (written != 0) {
        return Ok(190);
    }
    return Ok(42);
}

fn roundtrip_write_tripletrynodefer_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_tripletrynodefer_main_template()?;
    let written: i32 = fs_write_text("bootstrap_tripletrynodefer_main.c.in", c_src);
    if (written != 0) {
        return Ok(191);
    }
    return Ok(42);
}

fn roundtrip_write_fxtry_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_fxtry_main_template()?;
    let written: i32 = fs_write_text("bootstrap_fxtry_main.c.in", c_src);
    if (written != 0) {
        return Ok(192);
    }
    return Ok(42);
}

fn roundtrip_write_fxtryok_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_fxtryok_main_template()?;
    let written: i32 = fs_write_text("bootstrap_fxtryok_main.c.in", c_src);
    if (written != 0) {
        return Ok(193);
    }
    return Ok(42);
}

fn roundtrip_write_fxtrynodefer_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_fxtrynodefer_main_template()?;
    let written: i32 = fs_write_text("bootstrap_fxtrynodefer_main.c.in", c_src);
    if (written != 0) {
        return Ok(194);
    }
    return Ok(42);
}

fn roundtrip_write_defertryarena_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_defertryarena_main_template()?;
    let written: i32 = fs_write_text("bootstrap_defertryarena_main.c.in", c_src);
    if (written != 0) {
        return Ok(195);
    }
    return Ok(42);
}

fn roundtrip_write_defertryarenaread_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_defertryarenaread_main_template()?;
    let written: i32 = fs_write_text("bootstrap_defertryarenaread_main.c.in", c_src);
    if (written != 0) {
        return Ok(196);
    }
    return Ok(42);
}

fn roundtrip_write_defertryokarena_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_defertryokarena_main_template()?;
    let written: i32 = fs_write_text("bootstrap_defertryokarena_main.c.in", c_src);
    if (written != 0) {
        return Ok(197);
    }
    return Ok(42);
}

fn roundtrip_write_deferwhile_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deferwhile_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deferwhile_main.c.in", c_src);
    if (written != 0) {
        return Ok(198);
    }
    return Ok(42);
}

fn roundtrip_write_deferbreak_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deferbreak_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deferbreak_main.c.in", c_src);
    if (written != 0) {
        return Ok(199);
    }
    return Ok(42);
}

fn roundtrip_write_deferfor_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deferfor_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deferfor_main.c.in", c_src);
    if (written != 0) {
        return Ok(200);
    }
    return Ok(42);
}

fn roundtrip_write_deferlifo_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deferlifo_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deferlifo_main.c.in", c_src);
    if (written != 0) {
        return Ok(201);
    }
    return Ok(42);
}

fn roundtrip_write_deferarena_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deferarena_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deferarena_main.c.in", c_src);
    if (written != 0) {
        return Ok(202);
    }
    return Ok(42);
}

fn roundtrip_write_deferarenaread_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_deferarenaread_main_template()?;
    let written: i32 = fs_write_text("bootstrap_deferarenaread_main.c.in", c_src);
    if (written != 0) {
        return Ok(203);
    }
    return Ok(42);
}

fn roundtrip_write_arena_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_arena_main_template()?;
    let written: i32 = fs_write_text("bootstrap_arena_main.c.in", c_src);
    if (written != 0) {
        return Ok(204);
    }
    return Ok(42);
}

fn roundtrip_write_tempderef_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_tempderef_main_template()?;
    let written: i32 = fs_write_text("bootstrap_tempderef_main.c.in", c_src);
    if (written != 0) {
        return Ok(205);
    }
    return Ok(42);
}

fn roundtrip_write_fxregion_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_fxregion_main_template()?;
    let written: i32 = fs_write_text("bootstrap_fxregion_main.c.in", c_src);
    if (written != 0) {
        return Ok(206);
    }
    return Ok(42);
}

fn roundtrip_write_arenaborrowempty_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_arenaborrowempty_main_template()?;
    let written: i32 = fs_write_text("bootstrap_arenaborrowempty_main.c.in", c_src);
    if (written != 0) {
        return Ok(207);
    }
    return Ok(42);
}

fn roundtrip_write_genericstruct_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstruct_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstruct_main.c.in", c_src);
    if (written != 0) {
        return Ok(208);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructinfer_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructinfer_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructinfer_main.c.in", c_src);
    if (written != 0) {
        return Ok(209);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructann_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructann_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructann_main.c.in", c_src);
    if (written != 0) {
        return Ok(210);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructfn_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructfn_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructfn_main.c.in", c_src);
    if (written != 0) {
        return Ok(211);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructfnret_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructfnret_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructfnret_main.c.in", c_src);
    if (written != 0) {
        return Ok(212);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructfnsig_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructfnsig_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructfnsig_main.c.in", c_src);
    if (written != 0) {
        return Ok(213);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructpair_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructpair_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructpair_main.c.in", c_src);
    if (written != 0) {
        return Ok(214);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructpairfn_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructpairfn_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructpairfn_main.c.in", c_src);
    if (written != 0) {
        return Ok(215);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructown_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructown_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructown_main.c.in", c_src);
    if (written != 0) {
        return Ok(216);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructmut_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructmut_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructmut_main.c.in", c_src);
    if (written != 0) {
        return Ok(217);
    }
    return Ok(42);
}

fn roundtrip_write_genericstructshared_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericstructshared_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericstructshared_main.c.in", c_src);
    if (written != 0) {
        return Ok(218);
    }
    return Ok(42);
}

fn roundtrip_write_genericboxowninfer_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericboxowninfer_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericboxowninfer_main.c.in", c_src);
    if (written != 0) {
        return Ok(219);
    }
    return Ok(42);
}

fn roundtrip_write_genericid_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericid_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericid_main.c.in", c_src);
    if (written != 0) {
        return Ok(220);
    }
    return Ok(42);
}

fn roundtrip_write_genericidmulti_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericidmulti_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericidmulti_main.c.in", c_src);
    if (written != 0) {
        return Ok(221);
    }
    return Ok(42);
}

fn roundtrip_write_genericvec_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericvec_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericvec_main.c.in", c_src);
    if (written != 0) {
        return Ok(222);
    }
    return Ok(42);
}

fn roundtrip_write_genericvecbool_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericvecbool_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericvecbool_main.c.in", c_src);
    if (written != 0) {
        return Ok(223);
    }
    return Ok(42);
}

fn roundtrip_write_genericvecnew_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericvecnew_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericvecnew_main.c.in", c_src);
    if (written != 0) {
        return Ok(224);
    }
    return Ok(42);
}

fn roundtrip_write_genericvecpush_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericvecpush_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericvecpush_main.c.in", c_src);
    if (written != 0) {
        return Ok(225);
    }
    return Ok(42);
}

fn roundtrip_write_genericvecpushbool_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericvecpushbool_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericvecpushbool_main.c.in", c_src);
    if (written != 0) {
        return Ok(226);
    }
    return Ok(42);
}

fn roundtrip_write_genericvecget_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_genericvecget_main_template()?;
    let written: i32 = fs_write_text("bootstrap_genericvecget_main.c.in", c_src);
    if (written != 0) {
        return Ok(227);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstruct_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstruct_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstruct_main.c.in", c_src);
    if (written != 0) {
        return Ok(228);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstructpair_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstructpair_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstructpair_main.c.in", c_src);
    if (written != 0) {
        return Ok(229);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstructown_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstructown_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstructown_main.c.in", c_src);
    if (written != 0) {
        return Ok(230);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstructmut_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstructmut_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstructmut_main.c.in", c_src);
    if (written != 0) {
        return Ok(231);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstructshared_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstructshared_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstructshared_main.c.in", c_src);
    if (written != 0) {
        return Ok(232);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstructvec_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstructvec_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstructvec_main.c.in", c_src);
    if (written != 0) {
        return Ok(233);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericstructvecbool_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericstructvecbool_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericstructvecbool_main.c.in", c_src);
    if (written != 0) {
        return Ok(234);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericvecpush_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericvecpush_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericvecpush_main.c.in", c_src);
    if (written != 0) {
        return Ok(235);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericvecpushbool_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericvecpushbool_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericvecpushbool_main.c.in", c_src);
    if (written != 0) {
        return Ok(236);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericvecget_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericvecget_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericvecget_main.c.in", c_src);
    if (written != 0) {
        return Ok(237);
    }
    return Ok(42);
}

fn roundtrip_write_importgenericvecgeti32_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importgenericvecgeti32_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importgenericvecgeti32_main.c.in", c_src);
    if (written != 0) {
        return Ok(238);
    }
    return Ok(42);
}

fn roundtrip_write_importarenagenericstructvec_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importarenagenericstructvec_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importarenagenericstructvec_main.c.in", c_src);
    if (written != 0) {
        return Ok(239);
    }
    return Ok(42);
}

fn roundtrip_write_importarenagenericstructvecbool_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importarenagenericstructvecbool_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importarenagenericstructvecbool_main.c.in", c_src);
    if (written != 0) {
        return Ok(240);
    }
    return Ok(42);
}

fn roundtrip_write_importarenagenericstructvecnew_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importarenagenericstructvecnew_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importarenagenericstructvecnew_main.c.in", c_src);
    if (written != 0) {
        return Ok(241);
    }
    return Ok(42);
}

fn roundtrip_write_importarenagenericstructvecnewbool_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importarenagenericstructvecnewbool_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importarenagenericstructvecnewbool_main.c.in", c_src);
    if (written != 0) {
        return Ok(242);
    }
    return Ok(42);
}

fn roundtrip_write_importstdvec_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdvec_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdvec_main.c.in", c_src);
    if (written != 0) {
        return Ok(243);
    }
    return Ok(42);
}

fn roundtrip_write_importstdvecarena_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdvecarena_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdvecarena_main.c.in", c_src);
    if (written != 0) {
        return Ok(244);
    }
    return Ok(42);
}

fn roundtrip_write_importstdvecarenapush_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdvecarenapush_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdvecarenapush_main.c.in", c_src);
    if (written != 0) {
        return Ok(245);
    }
    return Ok(42);
}

fn roundtrip_write_importstdvecreadwrite_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdvecreadwrite_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdvecreadwrite_main.c.in", c_src);
    if (written != 0) {
        return Ok(246);
    }
    return Ok(42);
}

fn roundtrip_write_importstdvecnewpromoted_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdvecnewpromoted_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdvecnewpromoted_main.c.in", c_src);
    if (written != 0) {
        return Ok(247);
    }
    return Ok(42);
}

fn roundtrip_write_importstdstringcompare_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdstringcompare_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdstringcompare_main.c.in", c_src);
    if (written != 0) {
        return Ok(248);
    }
    return Ok(42);
}

fn roundtrip_write_importstdstringconcat_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdstringconcat_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdstringconcat_main.c.in", c_src);
    if (written != 0) {
        return Ok(249);
    }
    return Ok(42);
}

fn roundtrip_write_importtransitive_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importtransitive_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importtransitive_main.c.in", c_src);
    if (written != 0) {
        return Ok(250);
    }
    return Ok(42);
}

fn roundtrip_write_importstdandlocal_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdandlocal_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdandlocal_main.c.in", c_src);
    if (written != 0) {
        return Ok(251);
    }
    return Ok(42);
}

fn roundtrip_write_importstdbox_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdbox_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdbox_main.c.in", c_src);
    if (written != 0) {
        return Ok(252);
    }
    return Ok(42);
}

fn roundtrip_write_importstdboxown_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdboxown_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdboxown_main.c.in", c_src);
    if (written != 0) {
        return Ok(253);
    }
    return Ok(42);
}

fn roundtrip_write_importstdboxmut_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdboxmut_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdboxmut_main.c.in", c_src);
    if (written != 0) {
        return Ok(254);
    }
    return Ok(42);
}

fn roundtrip_write_importstdpair_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdpair_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdpair_main.c.in", c_src);
    if (written != 0) {
        return Ok(255);
    }
    return Ok(42);
}

fn roundtrip_write_importstdpairsecond_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdpairsecond_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdpairsecond_main.c.in", c_src);
    if (written != 0) {
        return Ok(256);
    }
    return Ok(42);
}

fn roundtrip_write_importstdmath_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdmath_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdmath_main.c.in", c_src);
    if (written != 0) {
        return Ok(257);
    }
    return Ok(42);
}

fn roundtrip_write_importstdmathsub_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdmathsub_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdmathsub_main.c.in", c_src);
    if (written != 0) {
        return Ok(258);
    }
    return Ok(42);
}

fn roundtrip_write_importstdio_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdio_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdio_main.c.in", c_src);
    if (written != 0) {
        return Ok(259);
    }
    return Ok(42);
}

fn roundtrip_write_importstdiosderr_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdiosderr_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdiosderr_main.c.in", c_src);
    if (written != 0) {
        return Ok(260);
    }
    return Ok(42);
}

fn roundtrip_write_importstdiofile_main_template() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.emit_importstdiofile_main_template()?;
    let written: i32 = fs_write_text("bootstrap_importstdiofile_main.c.in", c_src);
    if (written != 0) {
        return Ok(261);
    }
    return Ok(42);
}

fn roundtrip_write_ok_main() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_main()?;
    let w1: i32 = fs_write_text("bootstrap_ok_main.c", c_src);
    if (w1 != 0) {
        return Ok(77);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_main_main(void);\nint main(void) {\n    return (int)fx_ok_main_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_shim.c", shim);
    if (w2 != 0) {
        return Ok(78);
    }
    return Ok(42);
}

fn roundtrip_write_ok_add() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_add()?;
    let w1: i32 = fs_write_text("bootstrap_ok_add.c", c_src);
    if (w1 != 0) {
        return Ok(79);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_add_main(void);\nint main(void) {\n    return (int)fx_ok_add_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_add_shim.c", shim);
    if (w2 != 0) {
        return Ok(80);
    }
    return Ok(42);
}

// SH-C-28 - write bootstrap-emitted lex-family C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_lexer_smoke() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_lexer_smoke()?;
    let w1: i32 = fs_write_text("bootstrap_lexer_smoke.c", c_src);
    if (w1 != 0) {
        return Ok(398);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_bootstrap_lexer_smoke_main(void);\nint main(void) {\n    return (int)fx_bootstrap_lexer_smoke_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_lexer_smoke_shim.c", shim);
    if (w2 != 0) {
        return Ok(399);
    }
    return Ok(42);
}

// SH-C-42 - write bootstrap-emitted real-lexer radius C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_lexer_radius() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_lexer_radius()?;
    let w1: i32 = fs_write_text("bootstrap_real_lexer_radius.c", c_src);
    if (w1 != 0) {
        return Ok(427);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_bootstrap_real_lexer_radius_main(void);\nint main(void) {\n    return (int)fx_bootstrap_real_lexer_radius_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_lexer_radius_shim.c", shim);
    if (w2 != 0) {
        return Ok(428);
    }
    return Ok(42);
}

// SH-C-43 - write bootstrap-emitted real-lexer full C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_lexer_full() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_lexer_full()?;
    let w1: i32 = fs_write_text("bootstrap_real_lexer_full.c", c_src);
    if (w1 != 0) {
        return Ok(438);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_lexer_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_lexer_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_lexer_full_shim.c", shim);
    if (w2 != 0) {
        return Ok(439);
    }
    return Ok(42);
}

// SH-C-29 - write bootstrap-emitted parse-family C for gcc -Werror round-trip.

// SH-C-45 - write bootstrap-emitted real-parse radius C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_parse_radius() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_radius()?;
    let w1: i32 = fs_write_text("bootstrap_real_parse_radius.c", c_src);
    if (w1 != 0) {
        return Ok(462);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_parse_radius_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_parse_radius_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_parse_radius_shim.c", shim);
    if (w2 != 0) {
        return Ok(463);
    }
    return Ok(42);
}

// SH-C-51 - write bootstrap-emitted real-parse recursive C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_parse_recursive() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_recursive()?;
    let w1: i32 = fs_write_text("bootstrap_real_parse_recursive.c", c_src);
    if (w1 != 0) {
        return Ok(504);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_parse_recursive_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_parse_recursive_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_parse_recursive_shim.c", shim);
    if (w2 != 0) {
        return Ok(505);
    }
    return Ok(42);
}

// SH-C-53 - write bootstrap-emitted real-parse expr-stmt C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_parse_expr_stmt() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_expr_stmt()?;
    let w1: i32 = fs_write_text("bootstrap_real_parse_expr_stmt.c", c_src);
    if (w1 != 0) {
        return Ok(524);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_parse_expr_stmt_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_parse_expr_stmt_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_parse_expr_stmt_shim.c", shim);
    if (w2 != 0) {
        return Ok(525);
    }
    return Ok(42);
}

// SH-C-72 - write bootstrap-emitted real-parse map export C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_parse_fn_def() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_parse_fn_def()?;
    let w1: i32 = fs_write_text("bootstrap_real_parse_fn_def.c", c_src);
    if (w1 != 0) {
        return Ok(546);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_parse_fn_def_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_parse_fn_def_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_parse_fn_def_shim.c", shim);
    if (w2 != 0) {
        return Ok(547);
    }
    return Ok(42);
}



































// SH-C-46 - write bootstrap-emitted real-emit radius C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_emit_radius() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_emit_radius()?;
    let w1: i32 = fs_write_text("bootstrap_real_emit_radius.c", c_src);
    if (w1 != 0) {
        return Ok(484);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_emit_radius_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_emit_radius_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_emit_radius_shim.c", shim);
    if (w2 != 0) {
        return Ok(485);
    }
    return Ok(42);
}

// SH-C-77/78/79/80 - write bootstrap-emitted real-emit module C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_real_emit_module() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_real_emit_module()?;
    let w1: i32 = fs_write_text("bootstrap_real_emit_module.c", c_src);
    if (w1 != 0) {
        return Ok(625);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_sh_emit_emit_module_smoke_tests(void);\nint main(void) {\n    return (int)fx_sh_emit_emit_module_smoke_tests();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_real_emit_module_shim.c", shim);
    if (w2 != 0) {
        return Ok(626);
    }
    return Ok(42);
}


fn roundtrip_write_bootstrap_parse_smoke() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_parse_smoke()?;
    let w1: i32 = fs_write_text("bootstrap_parse_smoke.c", c_src);
    if (w1 != 0) {
        return Ok(407);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_bootstrap_parse_smoke_main(void);\nint main(void) {\n    return (int)fx_bootstrap_parse_smoke_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_parse_smoke_shim.c", shim);
    if (w2 != 0) {
        return Ok(408);
    }
    return Ok(42);
}

// SH-C-30 - write bootstrap-emitted emit-family C for gcc -Werror round-trip.
fn roundtrip_write_bootstrap_emit_smoke() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_bootstrap_emit_smoke()?;
    let w1: i32 = fs_write_text("bootstrap_emit_smoke.c", c_src);
    if (w1 != 0) {
        return Ok(417);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_bootstrap_emit_smoke_main(void);\nint main(void) {\n    return (int)fx_bootstrap_emit_smoke_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_emit_smoke_shim.c", shim);
    if (w2 != 0) {
        return Ok(418);
    }
    return Ok(42);
}

fn roundtrip_write_ok_hello() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_hello()?;
    let w1: i32 = fs_write_text("bootstrap_ok_hello.c", c_src);
    if (w1 != 0) {
        return Ok(81);
    }
    let shim: string = "#include <stdint.h>\n#include <stdio.h>\nint32_t fx_ok_hello_main(void);\nint main(void) {\n    return (int)fx_ok_hello_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_hello_shim.c", shim);
    if (w2 != 0) {
        return Ok(82);
    }
    return Ok(42);
}

fn roundtrip_write_ok_color_match() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_color_match()?;
    let w1: i32 = fs_write_text("bootstrap_ok_color_match.c", c_src);
    if (w1 != 0) {
        return Ok(91);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_color_match_main(void);\nint main(void) {\n    return (int)fx_ok_color_match_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_color_match_shim.c", shim);
    if (w2 != 0) {
        return Ok(92);
    }
    return Ok(42);
}

fn roundtrip_write_ok_band_match() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_band_match()?;
    let w1: i32 = fs_write_text("bootstrap_ok_band_match.c", c_src);
    if (w1 != 0) {
        return Ok(93);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_band_match_main(void);\nint main(void) {\n    return (int)fx_ok_band_match_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_band_match_shim.c", shim);
    if (w2 != 0) {
        return Ok(94);
    }
    return Ok(42);
}

fn roundtrip_write_ok_import() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let math_src: string = sh_parse.parse_and_emit_bootstrap_math()?;
    let w0: i32 = fs_write_text("bootstrap_math.c", math_src);
    if (w0 != 0) {
        return Ok(95);
    }
    let math_h: string = "#ifndef FX_MATH_H\n#define FX_MATH_H\n#include <stdint.h>\nint32_t fx_math_add(int32_t a, int32_t b);\n#endif\n";
    let w0h: i32 = fs_write_text("math.h", math_h);
    if (w0h != 0) {
        return Ok(96);
    }
    let c_src: string = sh_parse.parse_and_emit_ok_import()?;
    let w1: i32 = fs_write_text("bootstrap_ok_import.c", c_src);
    if (w1 != 0) {
        return Ok(97);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_import_main(void);\nint main(void) {\n    return (int)fx_ok_import_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_import_shim.c", shim);
    if (w2 != 0) {
        return Ok(98);
    }
    return Ok(42);
}

fn roundtrip_write_ok_struct_field() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_struct_field()?;
    let w1: i32 = fs_write_text("bootstrap_ok_struct_field.c", c_src);
    if (w1 != 0) {
        return Ok(99);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_struct_field_main(void);\nint main(void) {\n    return (int)fx_ok_struct_field_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_struct_field_shim.c", shim);
    if (w2 != 0) {
        return Ok(100);
    }
    return Ok(42);
}

fn roundtrip_write_ok_struct_return() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_struct_return()?;
    let w1: i32 = fs_write_text("bootstrap_ok_struct_return.c", c_src);
    if (w1 != 0) {
        return Ok(101);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_struct_return_main(void);\nint main(void) {\n    return (int)fx_ok_struct_return_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_struct_return_shim.c", shim);
    if (w2 != 0) {
        return Ok(102);
    }
    return Ok(42);
}

fn roundtrip_write_ok_enum_payload() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload()?;
    let w1: i32 = fs_write_text("bootstrap_ok_enum_payload.c", c_src);
    if (w1 != 0) {
        return Ok(105);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_enum_payload_main(void);\nint main(void) {\n    return (int)fx_ok_enum_payload_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_enum_payload_shim.c", shim);
    if (w2 != 0) {
        return Ok(106);
    }
    return Ok(42);
}

fn roundtrip_write_bootstrap_self_subset() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let std_stub: string = "#ifndef FX_STD_STUB_H\n#define FX_STD_STUB_H\n#include <stdint.h>\n#endif\n";
    let w0s1: i32 = fs_write_text("std/fx_defaults.h", std_stub);
    if (w0s1 != 0) {
        return Ok(100);
    }
    let w0s2: i32 = fs_write_text("std/string.h", std_stub);
    if (w0s2 != 0) {
        return Ok(101);
    }
    let lexer_h: string = "#ifndef FX_SH_LEXER_H\n#define FX_SH_LEXER_H\n#include <stdint.h>\n#include <string.h>\n#include \"zspec/core.h\"\ntypedef struct {\n    int32_t tag;\n    const char* ok_val;\n    core_Err err_val;\n} fx_lib_sh_lexer_Result_string;\nstatic inline int32_t fx_lib_sh_lexer_slice_eq(const char* src, int32_t start, int32_t len, const char* lit) {\n    size_t lit_len = strlen(lit);\n    if ((int32_t)lit_len != len) {\n        return 0;\n    }\n    return memcmp(src + start, lit, lit_len) == 0 ? 1 : 0;\n}\nfx_lib_sh_lexer_Result_string fx_lib_sh_lexer_slice_str(const char* src, int32_t start, int32_t len);\nconst char* fx_lib_sh_lexer_ident_char_str(int32_t b);\n#endif\n";
    let w0h: i32 = fs_write_text("lib/sh_lexer.h", lexer_h);
    if (w0h != 0) {
        return Ok(102);
    }
    let diag_h: string = "#ifndef FX_SH_DIAG_H\n#define FX_SH_DIAG_H\n#include <stdint.h>\n#endif\n";
    let w0d: i32 = fs_write_text("lib/sh_diag.h", diag_h);
    if (w0d != 0) {
        return Ok(103);
    }
    let c_src: string = sh_parse.parse_and_emit_bootstrap_self_subset()?;
    let w1: i32 = fs_write_text("lib/bootstrap_self_subset.c", c_src);
    if (w1 != 0) {
        return Ok(104);
    }
    let shim: string = "#include <stdint.h>\n#include \"lib/sh_lexer.h\"\n#define FX_RESULT_TAG_OK 0\n#define FX_RESULT_TAG_ERR 1\nfx_lib_sh_lexer_Result_string fx_lib_sh_lexer_slice_str(const char* src, int32_t start, int32_t len) {\n    if (len <= 0) {\n        return (fx_lib_sh_lexer_Result_string){ .tag = FX_RESULT_TAG_OK, .ok_val = \"\", .err_val = CORE_OK };\n    }\n    return (fx_lib_sh_lexer_Result_string){ .tag = FX_RESULT_TAG_OK, .ok_val = src + start, .err_val = CORE_OK };\n}\nconst char* fx_lib_sh_lexer_ident_char_str(int32_t b) {\n    if (b == 40) { return \"(\"; }\n    if (b == 41) { return \")\"; }\n    if (b == 124) { return \"|\"; }\n    return \"\";\n}\nint32_t fx_bootstrap_self_subset_main(void);\nint main(void) {\n    return (int)fx_bootstrap_self_subset_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_self_subset_shim.c", shim);
    if (w2 != 0) {
        return Ok(105);
    }
    return Ok(42);
}

fn roundtrip_write_ok_enum_payload_multi() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_multi()?;
    let w1: i32 = fs_write_text("bootstrap_ok_enum_payload_multi.c", c_src);
    if (w1 != 0) {
        return Ok(88);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_enum_payload_multi_main(void);\nint main(void) {\n    return (int)fx_ok_enum_payload_multi_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_enum_payload_multi_shim.c", shim);
    if (w2 != 0) {
        return Ok(89);
    }
    return Ok(42);
}

fn roundtrip_write_ok_enum_payload_string() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_string()?;
    let w1: i32 = fs_write_text("bootstrap_ok_enum_payload_string.c", c_src);
    if (w1 != 0) {
        return Ok(90);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_enum_payload_string_main(void);\nint main(void) {\n    return (int)fx_ok_enum_payload_string_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_enum_payload_string_shim.c", shim);
    if (w2 != 0) {
        return Ok(91);
    }
    return Ok(42);
}

fn roundtrip_write_ok_enum_payload_mixed() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_mixed()?;
    let w1: i32 = fs_write_text("bootstrap_ok_enum_payload_mixed.c", c_src);
    if (w1 != 0) {
        return Ok(92);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_enum_payload_mixed_main(void);\nint main(void) {\n    return (int)fx_ok_enum_payload_mixed_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_enum_payload_mixed_shim.c", shim);
    if (w2 != 0) {
        return Ok(93);
    }
    return Ok(42);
}

fn roundtrip_write_ok_enum_payload_ignore() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_enum_payload_ignore()?;
    let w1: i32 = fs_write_text("bootstrap_ok_enum_payload_ignore.c", c_src);
    if (w1 != 0) {
        return Ok(116);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_enum_payload_ignore_main(void);\nint main(void) {\n    return (int)fx_ok_enum_payload_ignore_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_enum_payload_ignore_shim.c", shim);
    if (w2 != 0) {
        return Ok(117);
    }
    return Ok(42);
}

fn roundtrip_write_ok_result_guard() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_result_guard()?;
    let w1: i32 = fs_write_text("bootstrap_ok_result_guard.c", c_src);
    if (w1 != 0) {
        return Ok(118);
    }
    let shim: string = "#include <stdint.h>\n#include \"zspec/core.h\"\n\ntypedef struct {\n    int32_t tag;\n    int32_t ok_val;\n    core_Err err_val;\n} fx_ok_result_guard_Result_i32;\n\nfx_ok_result_guard_Result_i32 fx_ok_result_guard_main(void);\n\nint main(void) {\n    fx_ok_result_guard_Result_i32 r = fx_ok_result_guard_main();\n    if (r.tag != 0) {\n        return (int)r.err_val;\n    }\n    return (int)r.ok_val;\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_result_guard_shim.c", shim);
    if (w2 != 0) {
        return Ok(119);
    }
    return Ok(42);
}

fn roundtrip_write_ok_using_core() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_using_core()?;
    let w1: i32 = fs_write_text("bootstrap_ok_using_core.c", c_src);
    if (w1 != 0) {
        return Ok(120);
    }
    let shim: string = "#include <stdint.h>\n#include \"zspec/core.h\"\n\ntypedef struct {\n    int32_t tag;\n    int32_t ok_val;\n    core_Err err_val;\n} fx_ok_using_core_Result_i32;\n\nfx_ok_using_core_Result_i32 fx_ok_using_core_main(void);\n\nint main(void) {\n    fx_ok_using_core_Result_i32 r = fx_ok_using_core_main();\n    if (r.tag != 0) {\n        return (int)r.err_val;\n    }\n    return (int)r.ok_val;\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_using_core_shim.c", shim);
    if (w2 != 0) {
        return Ok(121);
    }
    return Ok(42);
}

fn roundtrip_write_ok_using_core_mem() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_using_core_mem()?;
    let w1: i32 = fs_write_text("bootstrap_ok_using_core_mem.c", c_src);
    if (w1 != 0) {
        return Ok(122);
    }
    let shim: string = "#include <stdint.h>\n#include \"zspec/core.h\"\n\ntypedef struct {\n    int32_t tag;\n    int32_t ok_val;\n    core_Err err_val;\n} fx_ok_using_core_mem_Result_i32;\n\nfx_ok_using_core_mem_Result_i32 fx_ok_using_core_mem_main(void);\n\nint main(void) {\n    fx_ok_using_core_mem_Result_i32 r = fx_ok_using_core_mem_main();\n    if (r.tag != 0) {\n        return (int)r.err_val;\n    }\n    return (int)r.ok_val;\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_using_core_mem_shim.c", shim);
    if (w2 != 0) {
        return Ok(123);
    }
    return Ok(42);
}

fn roundtrip_write_ok_using_core_io() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_using_core_io()?;
    let w1: i32 = fs_write_text("bootstrap_ok_using_core_io.c", c_src);
    if (w1 != 0) {
        return Ok(124);
    }
    let shim: string = "#include <stdint.h>\n#include \"zspec/core.h\"\n\ntypedef struct {\n    int32_t tag;\n    int32_t ok_val;\n    core_Err err_val;\n} fx_ok_using_core_io_Result_i32;\n\nfx_ok_using_core_io_Result_i32 fx_ok_using_core_io_main(void);\n\nint main(void) {\n    fx_ok_using_core_io_Result_i32 r = fx_ok_using_core_io_main();\n    if (r.tag != 0) {\n        return (int)r.err_val;\n    }\n    return (int)r.ok_val;\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_using_core_io_shim.c", shim);
    if (w2 != 0) {
        return Ok(125);
    }
    return Ok(42);
}

fn roundtrip_write_ok_using_core_string() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_using_core_string()?;
    let w1: i32 = fs_write_text("bootstrap_ok_using_core_string.c", c_src);
    if (w1 != 0) {
        return Ok(126);
    }
    let shim: string = "#include <stdint.h>\n#include \"zspec/core.h\"\n\ntypedef struct {\n    int32_t tag;\n    int32_t ok_val;\n    core_Err err_val;\n} fx_ok_using_core_string_Result_i32;\n\nfx_ok_using_core_string_Result_i32 fx_ok_using_core_string_main(void);\n\nint main(void) {\n    fx_ok_using_core_string_Result_i32 r = fx_ok_using_core_string_main();\n    if (r.tag != 0) {\n        return (int)r.err_val;\n    }\n    return (int)r.ok_val;\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_using_core_string_shim.c", shim);
    if (w2 != 0) {
        return Ok(127);
    }
    return Ok(42);
}

fn roundtrip_write_ok_vec_enum() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_vec_enum()?;
    let w1: i32 = fs_write_text("bootstrap_ok_vec_enum.c", c_src);
    if (w1 != 0) {
        return Ok(94);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_vec_enum_main(void);\nint main(void) {\n    return (int)fx_ok_vec_enum_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_vec_enum_shim.c", shim);
    if (w2 != 0) {
        return Ok(95);
    }
    return Ok(42);
}

fn roundtrip_write_ok_while_zero() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_while_zero()?;
    let w1: i32 = fs_write_text("bootstrap_ok_while_zero.c", c_src);
    if (w1 != 0) {
        return Ok(96);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_while_zero_main(void);\nint main(void) {\n    return (int)fx_ok_while_zero_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_while_zero_shim.c", shim);
    if (w2 != 0) {
        return Ok(97);
    }
    return Ok(42);
}

fn roundtrip_write_ok_if_else() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_if_else()?;
    let w1: i32 = fs_write_text("bootstrap_ok_if_else.c", c_src);
    if (w1 != 0) {
        return Ok(98);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_if_else_main(void);\nint main(void) {\n    return (int)fx_ok_if_else_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_if_else_shim.c", shim);
    if (w2 != 0) {
        return Ok(99);
    }
    return Ok(42);
}

fn roundtrip_write_ok_break() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_break()?;
    let w1: i32 = fs_write_text("bootstrap_ok_break.c", c_src);
    if (w1 != 0) {
        return Ok(100);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_break_main(void);\nint main(void) {\n    return (int)fx_ok_break_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_break_shim.c", shim);
    if (w2 != 0) {
        return Ok(101);
    }
    return Ok(42);
}

fn roundtrip_write_ok_for_sum() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_for_sum()?;
    let w1: i32 = fs_write_text("bootstrap_ok_for_sum.c", c_src);
    if (w1 != 0) {
        return Ok(102);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_for_sum_main(void);\nint main(void) {\n    return (int)fx_ok_for_sum_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_for_sum_shim.c", shim);
    if (w2 != 0) {
        return Ok(103);
    }
    return Ok(42);
}

fn roundtrip_write_ok_continue() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_continue()?;
    let w1: i32 = fs_write_text("bootstrap_ok_continue.c", c_src);
    if (w1 != 0) {
        return Ok(104);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_continue_main(void);\nint main(void) {\n    return (int)fx_ok_continue_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_continue_shim.c", shim);
    if (w2 != 0) {
        return Ok(105);
    }
    return Ok(42);
}

fn roundtrip_write_ok_cmp_lt() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_cmp_lt()?;
    let w1: i32 = fs_write_text("bootstrap_ok_cmp_lt.c", c_src);
    if (w1 != 0) {
        return Ok(106);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_cmp_lt_main(void);\nint main(void) {\n    return (int)fx_ok_cmp_lt_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_cmp_lt_shim.c", shim);
    if (w2 != 0) {
        return Ok(107);
    }
    return Ok(42);
}

fn roundtrip_write_ok_effect_pure_call() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_effect_pure_call()?;
    let w1: i32 = fs_write_text("bootstrap_ok_effect_pure_call.c", c_src);
    if (w1 != 0) {
        return Ok(108);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_effect_pure_call_main(void);\nint main(void) {\n    return (int)fx_ok_effect_pure_call_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_effect_pure_call_shim.c", shim);
    if (w2 != 0) {
        return Ok(109);
    }
    return Ok(42);
}

fn roundtrip_write_ok_effect_io() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_effect_io()?;
    let w1: i32 = fs_write_text("bootstrap_ok_effect_io.c", c_src);
    if (w1 != 0) {
        return Ok(110);
    }
    let shim: string = "#include <stdint.h>\n#include <stdio.h>\nint32_t fx_ok_effect_io_main(void);\nint main(void) {\n    return (int)fx_ok_effect_io_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_effect_io_shim.c", shim);
    if (w2 != 0) {
        return Ok(111);
    }
    return Ok(42);
}

fn roundtrip_write_ok_extern_call() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_extern_call()?;
    let w1: i32 = fs_write_text("bootstrap_ok_extern_call.c", c_src);
    if (w1 != 0) {
        return Ok(112);
    }
    let shim: string = "#include <stdint.h>\nint32_t my_add(int32_t a, int32_t b) { return a + b; }\nint32_t fx_ok_extern_call_main(void);\nint main(void) {\n    return (int)fx_ok_extern_call_main();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_extern_call_shim.c", shim);
    if (w2 != 0) {
        return Ok(113);
    }
    return Ok(42);
}

fn roundtrip_write_ok_char_lit() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let c_src: string = sh_parse.parse_and_emit_ok_char_lit()?;
    let w1: i32 = fs_write_text("bootstrap_ok_char_lit.c", c_src);
    if (w1 != 0) {
        return Ok(114);
    }
    let shim: string = "#include <stdint.h>\nint32_t fx_ok_char_lit_codes(void);\nint main(void) {\n    return (int)fx_ok_char_lit_codes();\n}\n";
    let w2: i32 = fs_write_text("bootstrap_ok_char_lit_shim.c", shim);
    if (w2 != 0) {
        return Ok(115);
    }
    return Ok(42);
}

fn roundtrip_write_fixtures() -> Result<i32, core_Err> effects { alloc, io, mut } {
    let template_ok: i32 = roundtrip_write_simple_main_template()?;
    if (template_ok != 42) {
        return Ok(template_ok);
    }
    let add_template_ok: i32 = roundtrip_write_add_main_template()?;
    if (add_template_ok != 42) {
        return Ok(add_template_ok);
    }
    let hello_template_ok: i32 = roundtrip_write_hello_main_template()?;
    if (hello_template_ok != 42) {
        return Ok(hello_template_ok);
    }
    let module_add_template_ok: i32 = roundtrip_write_module_add_template()?;
    if (module_add_template_ok != 42) {
        return Ok(module_add_template_ok);
    }
    let import_add_template_ok: i32 = roundtrip_write_import_add_main_template()?;
    if (import_add_template_ok != 42) {
        return Ok(import_add_template_ok);
    }
    let struct_template_ok: i32 = roundtrip_write_struct_field_main_template()?;
    if (struct_template_ok != 42) {
        return Ok(struct_template_ok);
    }
    let struct_return_template_ok: i32 = roundtrip_write_struct_return_main_template()?;
    if (struct_return_template_ok != 42) {
        return Ok(struct_return_template_ok);
    }
    let color_template_ok: i32 = roundtrip_write_color_match_main_template()?;
    if (color_template_ok != 42) {
        return Ok(color_template_ok);
    }
    let band_template_ok: i32 = roundtrip_write_band_match_main_template()?;
    if (band_template_ok != 42) {
        return Ok(band_template_ok);
    }
    let nested_template_ok: i32 = roundtrip_write_nested_match_main_template()?;
    if (nested_template_ok != 42) {
        return Ok(nested_template_ok);
    }
    let payload_template_ok: i32 = roundtrip_write_enum_payload_main_template()?;
    if (payload_template_ok != 42) {
        return Ok(payload_template_ok);
    }
    let multi_template_ok: i32 = roundtrip_write_enum_payload_multi_main_template()?;
    if (multi_template_ok != 42) {
        return Ok(multi_template_ok);
    }
    let string_template_ok: i32 = roundtrip_write_enum_payload_string_main_template()?;
    if (string_template_ok != 42) {
        return Ok(string_template_ok);
    }
    let mixed_template_ok: i32 = roundtrip_write_enum_payload_mixed_main_template()?;
    if (mixed_template_ok != 42) {
        return Ok(mixed_template_ok);
    }
    let vec_template_ok: i32 = roundtrip_write_vec_enum_main_template()?;
    if (vec_template_ok != 42) {
        return Ok(vec_template_ok);
    }
    let while_template_ok: i32 = roundtrip_write_while_zero_main_template()?;
    if (while_template_ok != 42) {
        return Ok(while_template_ok);
    }
    let if_template_ok: i32 = roundtrip_write_if_else_main_template()?;
    if (if_template_ok != 42) {
        return Ok(if_template_ok);
    }
    let break_template_ok: i32 = roundtrip_write_break_main_template()?;
    if (break_template_ok != 42) {
        return Ok(break_template_ok);
    }
    let for_sum_template_ok: i32 = roundtrip_write_for_sum_main_template()?;
    if (for_sum_template_ok != 42) {
        return Ok(for_sum_template_ok);
    }
    let continue_template_ok: i32 = roundtrip_write_continue_main_template()?;
    if (continue_template_ok != 42) {
        return Ok(continue_template_ok);
    }
    let cmp_lt_template_ok: i32 = roundtrip_write_cmp_lt_main_template()?;
    if (cmp_lt_template_ok != 42) {
        return Ok(cmp_lt_template_ok);
    }
    let pure_call_template_ok: i32 = roundtrip_write_pure_call_main_template()?;
    if (pure_call_template_ok != 42) {
        return Ok(pure_call_template_ok);
    }
    let effect_io_template_ok: i32 = roundtrip_write_effect_io_main_template()?;
    if (effect_io_template_ok != 42) {
        return Ok(effect_io_template_ok);
    }
    let extern_call_template_ok: i32 = roundtrip_write_extern_call_main_template()?;
    if (extern_call_template_ok != 42) {
        return Ok(extern_call_template_ok);
    }
    let char_lit_template_ok: i32 = roundtrip_write_char_lit_main_template()?;
    if (char_lit_template_ok != 42) {
        return Ok(char_lit_template_ok);
    }
    let ignore_template_ok: i32 = roundtrip_write_enum_payload_ignore_main_template()?;
    if (ignore_template_ok != 42) {
        return Ok(ignore_template_ok);
    }
    let result_guard_template_ok: i32 = roundtrip_write_result_guard_main_template()?;
    if (result_guard_template_ok != 42) {
        return Ok(result_guard_template_ok);
    }
    let using_core_template_ok: i32 = roundtrip_write_using_core_main_template()?;
    if (using_core_template_ok != 42) {
        return Ok(using_core_template_ok);
    }
    let field_assign_template_ok: i32 = roundtrip_write_struct_field_assign_main_template()?;
    if (field_assign_template_ok != 42) {
        return Ok(field_assign_template_ok);
    }
    let defer_template_ok: i32 = roundtrip_write_defer_main_template()?;
    if (defer_template_ok != 42) {
        return Ok(defer_template_ok);
    }
    let own_move_template_ok: i32 = roundtrip_write_struct_own_move_main_template()?;
    if (own_move_template_ok != 42) {
        return Ok(own_move_template_ok);
    }
    let mut_field_template_ok: i32 = roundtrip_write_struct_mut_field_main_template()?;
    if (mut_field_template_ok != 42) {
        return Ok(mut_field_template_ok);
    }
    let shared_field_template_ok: i32 = roundtrip_write_struct_shared_field_main_template()?;
    if (shared_field_template_ok != 42) {
        return Ok(shared_field_template_ok);
    }
    let borrow_mut_template_ok: i32 = roundtrip_write_borrow_mut_main_template()?;
    if (borrow_mut_template_ok != 42) {
        return Ok(borrow_mut_template_ok);
    }
    let own_i32_move_template_ok: i32 = roundtrip_write_own_i32_move_main_template()?;
    if (own_i32_move_template_ok != 42) {
        return Ok(own_i32_move_template_ok);
    }
    let deref_assign_mut_template_ok: i32 = roundtrip_write_deref_assign_mut_main_template()?;
    if (deref_assign_mut_template_ok != 42) {
        return Ok(deref_assign_mut_template_ok);
    }
    let neg_template_ok: i32 = roundtrip_write_neg_main_template()?;
    if (neg_template_ok != 42) {
        return Ok(neg_template_ok);
    }
    let logic_template_ok: i32 = roundtrip_write_logic_main_template()?;
    if (logic_template_ok != 42) {
        return Ok(logic_template_ok);
    }
    let bitshift_template_ok: i32 = roundtrip_write_bitshift_main_template()?;
    if (bitshift_template_ok != 42) {
        return Ok(bitshift_template_ok);
    }
    let bits_template_ok: i32 = roundtrip_write_bits_main_template()?;
    if (bits_template_ok != 42) {
        return Ok(bits_template_ok);
    }
    let modulo_template_ok: i32 = roundtrip_write_modulo_main_template()?;
    if (modulo_template_ok != 42) {
        return Ok(modulo_template_ok);
    }
    let cast_template_ok: i32 = roundtrip_write_cast_main_template()?;
    if (cast_template_ok != 42) {
        return Ok(cast_template_ok);
    }
    let unsigned_template_ok: i32 = roundtrip_write_unsigned_main_template()?;
    if (unsigned_template_ok != 42) {
        return Ok(unsigned_template_ok);
    }
    let guard_template_ok: i32 = roundtrip_write_guard_main_template()?;
    if (guard_template_ok != 42) {
        return Ok(guard_template_ok);
    }
    let array_template_ok: i32 = roundtrip_write_array_main_template()?;
    if (array_template_ok != 42) {
        return Ok(array_template_ok);
    }
    let slice_template_ok: i32 = roundtrip_write_slice_main_template()?;
    if (slice_template_ok != 42) {
        return Ok(slice_template_ok);
    }
    let scoperel_template_ok: i32 = roundtrip_write_scoperel_main_template()?;
    if (scoperel_template_ok != 42) {
        return Ok(scoperel_template_ok);
    }
    let scopederef_template_ok: i32 = roundtrip_write_scopederef_main_template()?;
    if (scopederef_template_ok != 42) {
        return Ok(scopederef_template_ok);
    }
    let regif_template_ok: i32 = roundtrip_write_regif_main_template()?;
    if (regif_template_ok != 42) {
        return Ok(regif_template_ok);
    }
    let regwhile_template_ok: i32 = roundtrip_write_regwhile_main_template()?;
    if (regwhile_template_ok != 42) {
        return Ok(regwhile_template_ok);
    }
    let regifelse_template_ok: i32 = roundtrip_write_regifelse_main_template()?;
    if (regifelse_template_ok != 42) {
        return Ok(regifelse_template_ok);
    }
    let regfor_template_ok: i32 = roundtrip_write_regfor_main_template()?;
    if (regfor_template_ok != 42) {
        return Ok(regfor_template_ok);
    }
    let regmatch_template_ok: i32 = roundtrip_write_regmatch_main_template()?;
    if (regmatch_template_ok != 42) {
        return Ok(regmatch_template_ok);
    }
    let regparam_template_ok: i32 = roundtrip_write_regparam_main_template()?;
    if (regparam_template_ok != 42) {
        return Ok(regparam_template_ok);
    }
    let regparamnest_template_ok: i32 = roundtrip_write_regparamnest_main_template()?;
    if (regparamnest_template_ok != 42) {
        return Ok(regparamnest_template_ok);
    }
    let regparamvec_template_ok: i32 = roundtrip_write_regparamvec_main_template()?;
    if (regparamvec_template_ok != 42) {
        return Ok(regparamvec_template_ok);
    }
    let vecdefer_template_ok: i32 = roundtrip_write_vecdefer_main_template()?;
    if (vecdefer_template_ok != 42) {
        return Ok(vecdefer_template_ok);
    }
    let fxnested_template_ok: i32 = roundtrip_write_fxnested_main_template()?;
    if (fxnested_template_ok != 42) {
        return Ok(fxnested_template_ok);
    }
    let fxtriple_template_ok: i32 = roundtrip_write_fxtriple_main_template()?;
    if (fxtriple_template_ok != 42) {
        return Ok(fxtriple_template_ok);
    }
    let tripletry_template_ok: i32 = roundtrip_write_tripletry_main_template()?;
    if (tripletry_template_ok != 42) {
        return Ok(tripletry_template_ok);
    }
    let tripletryok_template_ok: i32 = roundtrip_write_tripletryok_main_template()?;
    if (tripletryok_template_ok != 42) {
        return Ok(tripletryok_template_ok);
    }
    let tripletrynodefer_template_ok: i32 = roundtrip_write_tripletrynodefer_main_template()?;
    if (tripletrynodefer_template_ok != 42) {
        return Ok(tripletrynodefer_template_ok);
    }
    let fxtry_template_ok: i32 = roundtrip_write_fxtry_main_template()?;
    if (fxtry_template_ok != 42) {
        return Ok(fxtry_template_ok);
    }
    let fxtryok_template_ok: i32 = roundtrip_write_fxtryok_main_template()?;
    if (fxtryok_template_ok != 42) {
        return Ok(fxtryok_template_ok);
    }
    let fxtrynodefer_template_ok: i32 = roundtrip_write_fxtrynodefer_main_template()?;
    if (fxtrynodefer_template_ok != 42) {
        return Ok(fxtrynodefer_template_ok);
    }
    let defertryarena_template_ok: i32 = roundtrip_write_defertryarena_main_template()?;
    if (defertryarena_template_ok != 42) {
        return Ok(defertryarena_template_ok);
    }
    let defertryarenaread_template_ok: i32 = roundtrip_write_defertryarenaread_main_template()?;
    if (defertryarenaread_template_ok != 42) {
        return Ok(defertryarenaread_template_ok);
    }
    let defertryokarena_template_ok: i32 = roundtrip_write_defertryokarena_main_template()?;
    if (defertryokarena_template_ok != 42) {
        return Ok(defertryokarena_template_ok);
    }
    let deferwhile_template_ok: i32 = roundtrip_write_deferwhile_main_template()?;
    if (deferwhile_template_ok != 42) {
        return Ok(deferwhile_template_ok);
    }
    let deferbreak_template_ok: i32 = roundtrip_write_deferbreak_main_template()?;
    if (deferbreak_template_ok != 42) {
        return Ok(deferbreak_template_ok);
    }
    let deferfor_template_ok: i32 = roundtrip_write_deferfor_main_template()?;
    if (deferfor_template_ok != 42) {
        return Ok(deferfor_template_ok);
    }
    let deferlifo_template_ok: i32 = roundtrip_write_deferlifo_main_template()?;
    if (deferlifo_template_ok != 42) {
        return Ok(deferlifo_template_ok);
    }
    let deferarena_template_ok: i32 = roundtrip_write_deferarena_main_template()?;
    if (deferarena_template_ok != 42) {
        return Ok(deferarena_template_ok);
    }
    let deferarenaread_template_ok: i32 = roundtrip_write_deferarenaread_main_template()?;
    if (deferarenaread_template_ok != 42) {
        return Ok(deferarenaread_template_ok);
    }
    let arena_template_ok: i32 = roundtrip_write_arena_main_template()?;
    if (arena_template_ok != 42) {
        return Ok(arena_template_ok);
    }
    let tempderef_template_ok: i32 = roundtrip_write_tempderef_main_template()?;
    if (tempderef_template_ok != 42) {
        return Ok(tempderef_template_ok);
    }
    let fxregion_template_ok: i32 = roundtrip_write_fxregion_main_template()?;
    if (fxregion_template_ok != 42) {
        return Ok(fxregion_template_ok);
    }
    let arenaborrowempty_template_ok: i32 = roundtrip_write_arenaborrowempty_main_template()?;
    if (arenaborrowempty_template_ok != 42) {
        return Ok(arenaborrowempty_template_ok);
    }
    let genericstruct_template_ok: i32 = roundtrip_write_genericstruct_main_template()?;
    if (genericstruct_template_ok != 42) {
        return Ok(genericstruct_template_ok);
    }
    let genericstructinfer_template_ok: i32 = roundtrip_write_genericstructinfer_main_template()?;
    if (genericstructinfer_template_ok != 42) {
        return Ok(genericstructinfer_template_ok);
    }
    let genericstructann_template_ok: i32 = roundtrip_write_genericstructann_main_template()?;
    if (genericstructann_template_ok != 42) {
        return Ok(genericstructann_template_ok);
    }
    let genericstructfn_template_ok: i32 = roundtrip_write_genericstructfn_main_template()?;
    if (genericstructfn_template_ok != 42) {
        return Ok(genericstructfn_template_ok);
    }
    let genericstructfnret_template_ok: i32 = roundtrip_write_genericstructfnret_main_template()?;
    if (genericstructfnret_template_ok != 42) {
        return Ok(genericstructfnret_template_ok);
    }
    let genericstructfnsig_template_ok: i32 = roundtrip_write_genericstructfnsig_main_template()?;
    if (genericstructfnsig_template_ok != 42) {
        return Ok(genericstructfnsig_template_ok);
    }
    let genericstructpair_template_ok: i32 = roundtrip_write_genericstructpair_main_template()?;
    if (genericstructpair_template_ok != 42) {
        return Ok(genericstructpair_template_ok);
    }
    let genericstructpairfn_template_ok: i32 = roundtrip_write_genericstructpairfn_main_template()?;
    if (genericstructpairfn_template_ok != 42) {
        return Ok(genericstructpairfn_template_ok);
    }
    let genericstructown_template_ok: i32 = roundtrip_write_genericstructown_main_template()?;
    if (genericstructown_template_ok != 42) {
        return Ok(genericstructown_template_ok);
    }
    let genericstructmut_template_ok: i32 = roundtrip_write_genericstructmut_main_template()?;
    if (genericstructmut_template_ok != 42) {
        return Ok(genericstructmut_template_ok);
    }
    let genericstructshared_template_ok: i32 = roundtrip_write_genericstructshared_main_template()?;
    if (genericstructshared_template_ok != 42) {
        return Ok(genericstructshared_template_ok);
    }
    let genericboxowninfer_template_ok: i32 = roundtrip_write_genericboxowninfer_main_template()?;
    if (genericboxowninfer_template_ok != 42) {
        return Ok(genericboxowninfer_template_ok);
    }
    let genericid_template_ok: i32 = roundtrip_write_genericid_main_template()?;
    if (genericid_template_ok != 42) {
        return Ok(genericid_template_ok);
    }
    let genericidmulti_template_ok: i32 = roundtrip_write_genericidmulti_main_template()?;
    if (genericidmulti_template_ok != 42) {
        return Ok(genericidmulti_template_ok);
    }
    let genericvec_template_ok: i32 = roundtrip_write_genericvec_main_template()?;
    if (genericvec_template_ok != 42) {
        return Ok(genericvec_template_ok);
    }
    let genericvecbool_template_ok: i32 = roundtrip_write_genericvecbool_main_template()?;
    if (genericvecbool_template_ok != 42) {
        return Ok(genericvecbool_template_ok);
    }
    let genericvecnew_template_ok: i32 = roundtrip_write_genericvecnew_main_template()?;
    if (genericvecnew_template_ok != 42) {
        return Ok(genericvecnew_template_ok);
    }
    let genericvecpush_template_ok: i32 = roundtrip_write_genericvecpush_main_template()?;
    if (genericvecpush_template_ok != 42) {
        return Ok(genericvecpush_template_ok);
    }
    let genericvecpushbool_template_ok: i32 = roundtrip_write_genericvecpushbool_main_template()?;
    if (genericvecpushbool_template_ok != 42) {
        return Ok(genericvecpushbool_template_ok);
    }
    let genericvecget_template_ok: i32 = roundtrip_write_genericvecget_main_template()?;
    if (genericvecget_template_ok != 42) {
        return Ok(genericvecget_template_ok);
    }
    let importgenericstruct_template_ok: i32 = roundtrip_write_importgenericstruct_main_template()?;
    if (importgenericstruct_template_ok != 42) {
        return Ok(importgenericstruct_template_ok);
    }
    let importgenericstructpair_template_ok: i32 = roundtrip_write_importgenericstructpair_main_template()?;
    if (importgenericstructpair_template_ok != 42) {
        return Ok(importgenericstructpair_template_ok);
    }
    let importgenericstructown_template_ok: i32 = roundtrip_write_importgenericstructown_main_template()?;
    if (importgenericstructown_template_ok != 42) {
        return Ok(importgenericstructown_template_ok);
    }
    let importgenericstructmut_template_ok: i32 = roundtrip_write_importgenericstructmut_main_template()?;
    if (importgenericstructmut_template_ok != 42) {
        return Ok(importgenericstructmut_template_ok);
    }
    let importgenericstructshared_template_ok: i32 = roundtrip_write_importgenericstructshared_main_template()?;
    if (importgenericstructshared_template_ok != 42) {
        return Ok(importgenericstructshared_template_ok);
    }
    let importgenericstructvec_template_ok: i32 = roundtrip_write_importgenericstructvec_main_template()?;
    if (importgenericstructvec_template_ok != 42) {
        return Ok(importgenericstructvec_template_ok);
    }
    let importgenericstructvecbool_template_ok: i32 = roundtrip_write_importgenericstructvecbool_main_template()?;
    if (importgenericstructvecbool_template_ok != 42) {
        return Ok(importgenericstructvecbool_template_ok);
    }
    let importgenericvecpush_template_ok: i32 = roundtrip_write_importgenericvecpush_main_template()?;
    if (importgenericvecpush_template_ok != 42) {
        return Ok(importgenericvecpush_template_ok);
    }
    let importgenericvecpushbool_template_ok: i32 = roundtrip_write_importgenericvecpushbool_main_template()?;
    if (importgenericvecpushbool_template_ok != 42) {
        return Ok(importgenericvecpushbool_template_ok);
    }
    let importgenericvecget_template_ok: i32 = roundtrip_write_importgenericvecget_main_template()?;
    if (importgenericvecget_template_ok != 42) {
        return Ok(importgenericvecget_template_ok);
    }
    let importgenericvecgeti32_template_ok: i32 = roundtrip_write_importgenericvecgeti32_main_template()?;
    if (importgenericvecgeti32_template_ok != 42) {
        return Ok(importgenericvecgeti32_template_ok);
    }
    let importarenagenericstructvec_template_ok: i32 = roundtrip_write_importarenagenericstructvec_main_template()?;
    if (importarenagenericstructvec_template_ok != 42) {
        return Ok(importarenagenericstructvec_template_ok);
    }
    let importarenagenericstructvecbool_template_ok: i32 = roundtrip_write_importarenagenericstructvecbool_main_template()?;
    if (importarenagenericstructvecbool_template_ok != 42) {
        return Ok(importarenagenericstructvecbool_template_ok);
    }
    let importarenagenericstructvecnew_template_ok: i32 = roundtrip_write_importarenagenericstructvecnew_main_template()?;
    if (importarenagenericstructvecnew_template_ok != 42) {
        return Ok(importarenagenericstructvecnew_template_ok);
    }
    let importarenagenericstructvecnewbool_template_ok: i32 = roundtrip_write_importarenagenericstructvecnewbool_main_template()?;
    if (importarenagenericstructvecnewbool_template_ok != 42) {
        return Ok(importarenagenericstructvecnewbool_template_ok);
    }
    let importstdvec_template_ok: i32 = roundtrip_write_importstdvec_main_template()?;
    if (importstdvec_template_ok != 42) {
        return Ok(importstdvec_template_ok);
    }
    let importstdvecarena_template_ok: i32 = roundtrip_write_importstdvecarena_main_template()?;
    if (importstdvecarena_template_ok != 42) {
        return Ok(importstdvecarena_template_ok);
    }
    let importstdvecarenapush_template_ok: i32 = roundtrip_write_importstdvecarenapush_main_template()?;
    if (importstdvecarenapush_template_ok != 42) {
        return Ok(importstdvecarenapush_template_ok);
    }
    let importstdvecreadwrite_template_ok: i32 = roundtrip_write_importstdvecreadwrite_main_template()?;
    if (importstdvecreadwrite_template_ok != 42) {
        return Ok(importstdvecreadwrite_template_ok);
    }
    let importstdvecnewpromoted_template_ok: i32 = roundtrip_write_importstdvecnewpromoted_main_template()?;
    if (importstdvecnewpromoted_template_ok != 42) {
        return Ok(importstdvecnewpromoted_template_ok);
    }
    let importstdstringcompare_template_ok: i32 = roundtrip_write_importstdstringcompare_main_template()?;
    if (importstdstringcompare_template_ok != 42) {
        return Ok(importstdstringcompare_template_ok);
    }
    let importstdstringconcat_template_ok: i32 = roundtrip_write_importstdstringconcat_main_template()?;
    if (importstdstringconcat_template_ok != 42) {
        return Ok(importstdstringconcat_template_ok);
    }
    let importtransitive_template_ok: i32 = roundtrip_write_importtransitive_main_template()?;
    if (importtransitive_template_ok != 42) {
        return Ok(importtransitive_template_ok);
    }
    let importstdandlocal_template_ok: i32 = roundtrip_write_importstdandlocal_main_template()?;
    if (importstdandlocal_template_ok != 42) {
        return Ok(importstdandlocal_template_ok);
    }
    let importstdbox_template_ok: i32 = roundtrip_write_importstdbox_main_template()?;
    if (importstdbox_template_ok != 42) {
        return Ok(importstdbox_template_ok);
    }
    let importstdboxown_template_ok: i32 = roundtrip_write_importstdboxown_main_template()?;
    if (importstdboxown_template_ok != 42) {
        return Ok(importstdboxown_template_ok);
    }
    let importstdboxmut_template_ok: i32 = roundtrip_write_importstdboxmut_main_template()?;
    if (importstdboxmut_template_ok != 42) {
        return Ok(importstdboxmut_template_ok);
    }
    let importstdpair_template_ok: i32 = roundtrip_write_importstdpair_main_template()?;
    if (importstdpair_template_ok != 42) {
        return Ok(importstdpair_template_ok);
    }
    let importstdpairsecond_template_ok: i32 = roundtrip_write_importstdpairsecond_main_template()?;
    if (importstdpairsecond_template_ok != 42) {
        return Ok(importstdpairsecond_template_ok);
    }
    let importstdmath_template_ok: i32 = roundtrip_write_importstdmath_main_template()?;
    if (importstdmath_template_ok != 42) {
        return Ok(importstdmath_template_ok);
    }
    let importstdmathsub_template_ok: i32 = roundtrip_write_importstdmathsub_main_template()?;
    if (importstdmathsub_template_ok != 42) {
        return Ok(importstdmathsub_template_ok);
    }
    let importstdio_template_ok: i32 = roundtrip_write_importstdio_main_template()?;
    if (importstdio_template_ok != 42) {
        return Ok(importstdio_template_ok);
    }
    let importstdiosderr_template_ok: i32 = roundtrip_write_importstdiosderr_main_template()?;
    if (importstdiosderr_template_ok != 42) {
        return Ok(importstdiosderr_template_ok);
    }
    let importstdiofile_template_ok: i32 = roundtrip_write_importstdiofile_main_template()?;
    if (importstdiofile_template_ok != 42) {
        return Ok(importstdiofile_template_ok);
    }
    let main_ok: i32 = roundtrip_write_ok_main()?;
    if (main_ok != 42) {
        return Ok(main_ok);
    }
    let add_ok: i32 = roundtrip_write_ok_add()?;
    if (add_ok != 42) {
        return Ok(add_ok);
    }
    let lex_smoke_ok: i32 = roundtrip_write_bootstrap_lexer_smoke()?;
    if (lex_smoke_ok != 42) {
        return Ok(lex_smoke_ok);
    }
    let real_lex_ok: i32 = roundtrip_write_bootstrap_real_lexer_radius()?;
    if (real_lex_ok != 42) {
        return Ok(real_lex_ok);
    }
    let real_lex_full_ok: i32 = roundtrip_write_bootstrap_real_lexer_full()?;
    let real_parse_radius_ok: i32 = roundtrip_write_bootstrap_real_parse_radius()?;
    if (real_parse_radius_ok != 42) {
        return Ok(real_parse_radius_ok);
    }
    let real_parse_recursive_ok: i32 = roundtrip_write_bootstrap_real_parse_recursive()?;
    if (real_parse_recursive_ok != 42) {
        return Ok(real_parse_recursive_ok);
    }
    let real_parse_expr_stmt_ok: i32 = roundtrip_write_bootstrap_real_parse_expr_stmt()?;
    if (real_parse_expr_stmt_ok != 42) {
        return Ok(real_parse_expr_stmt_ok);
    }
    let real_parse_fn_def_ok: i32 = roundtrip_write_bootstrap_real_parse_fn_def()?;
    if (real_parse_fn_def_ok != 42) {
        return Ok(real_parse_fn_def_ok);
    }
    let real_emit_radius_ok: i32 = roundtrip_write_bootstrap_real_emit_radius()?;
    if (real_emit_radius_ok != 42) {
        return Ok(real_emit_radius_ok);
    }
    let real_emit_module_ok: i32 = roundtrip_write_bootstrap_real_emit_module()?;
    if (real_emit_module_ok != 42) {
        return Ok(real_emit_module_ok);
    }
    if (real_lex_full_ok != 42) {
        return Ok(real_lex_full_ok);
    }
    let parse_smoke_ok: i32 = roundtrip_write_bootstrap_parse_smoke()?;
    if (parse_smoke_ok != 42) {
        return Ok(parse_smoke_ok);
    }
    let emit_smoke_ok: i32 = roundtrip_write_bootstrap_emit_smoke()?;
    if (emit_smoke_ok != 42) {
        return Ok(emit_smoke_ok);
    }
    let hello_ok: i32 = roundtrip_write_ok_hello()?;
    if (hello_ok != 42) {
        return Ok(hello_ok);
    }
    let import_ok: i32 = roundtrip_write_ok_import()?;
    if (import_ok != 42) {
        return Ok(import_ok);
    }
    let struct_ok: i32 = roundtrip_write_ok_struct_field()?;
    if (struct_ok != 42) {
        return Ok(struct_ok);
    }
    let struct_ret_ok: i32 = roundtrip_write_ok_struct_return()?;
    if (struct_ret_ok != 42) {
        return Ok(struct_ret_ok);
    }
    let color_ok: i32 = roundtrip_write_ok_color_match()?;
    if (color_ok != 42) {
        return Ok(color_ok);
    }
    let band_ok: i32 = roundtrip_write_ok_band_match()?;
    if (band_ok != 42) {
        return Ok(band_ok);
    }
    let enum_payload_ok: i32 = roundtrip_write_ok_enum_payload()?;
    if (enum_payload_ok != 42) {
        return Ok(enum_payload_ok);
    }
    let enum_multi_ok: i32 = roundtrip_write_ok_enum_payload_multi()?;
    if (enum_multi_ok != 42) {
        return Ok(enum_multi_ok);
    }
    let enum_str_ok: i32 = roundtrip_write_ok_enum_payload_string()?;
    if (enum_str_ok != 42) {
        return Ok(enum_str_ok);
    }
    let enum_mix_ok: i32 = roundtrip_write_ok_enum_payload_mixed()?;
    if (enum_mix_ok != 42) {
        return Ok(enum_mix_ok);
    }
    let enum_ignore_ok: i32 = roundtrip_write_ok_enum_payload_ignore()?;
    if (enum_ignore_ok != 42) {
        return Ok(enum_ignore_ok);
    }
    let result_guard_ok: i32 = roundtrip_write_ok_result_guard()?;
    if (result_guard_ok != 42) {
        return Ok(result_guard_ok);
    }
    let using_core_ok: i32 = roundtrip_write_ok_using_core()?;
    if (using_core_ok != 42) {
        return Ok(using_core_ok);
    }
    let using_core_mem_ok: i32 = roundtrip_write_ok_using_core_mem()?;
    if (using_core_mem_ok != 42) {
        return Ok(using_core_mem_ok);
    }
    let using_core_io_ok: i32 = roundtrip_write_ok_using_core_io()?;
    if (using_core_io_ok != 42) {
        return Ok(using_core_io_ok);
    }
    let using_core_string_ok: i32 = roundtrip_write_ok_using_core_string()?;
    if (using_core_string_ok != 42) {
        return Ok(using_core_string_ok);
    }
    let vec_enum_ok: i32 = roundtrip_write_ok_vec_enum()?;
    if (vec_enum_ok != 42) {
        return Ok(vec_enum_ok);
    }
    let while_zero_ok: i32 = roundtrip_write_ok_while_zero()?;
    if (while_zero_ok != 42) {
        return Ok(while_zero_ok);
    }
    let if_else_ok: i32 = roundtrip_write_ok_if_else()?;
    if (if_else_ok != 42) {
        return Ok(if_else_ok);
    }
    let break_ok: i32 = roundtrip_write_ok_break()?;
    if (break_ok != 42) {
        return Ok(break_ok);
    }
    let for_sum_ok: i32 = roundtrip_write_ok_for_sum()?;
    if (for_sum_ok != 42) {
        return Ok(for_sum_ok);
    }
    let continue_ok: i32 = roundtrip_write_ok_continue()?;
    if (continue_ok != 42) {
        return Ok(continue_ok);
    }
    let cmp_lt_ok: i32 = roundtrip_write_ok_cmp_lt()?;
    if (cmp_lt_ok != 42) {
        return Ok(cmp_lt_ok);
    }
    let pure_call_ok: i32 = roundtrip_write_ok_effect_pure_call()?;
    if (pure_call_ok != 42) {
        return Ok(pure_call_ok);
    }
    let effect_io_ok: i32 = roundtrip_write_ok_effect_io()?;
    if (effect_io_ok != 42) {
        return Ok(effect_io_ok);
    }
    let extern_call_ok: i32 = roundtrip_write_ok_extern_call()?;
    if (extern_call_ok != 42) {
        return Ok(extern_call_ok);
    }
    let char_lit_ok: i32 = roundtrip_write_ok_char_lit()?;
    if (char_lit_ok != 42) {
        return Ok(char_lit_ok);
    }
    return roundtrip_write_bootstrap_self_subset();
}
