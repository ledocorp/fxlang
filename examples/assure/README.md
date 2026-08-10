# assure -  dogfood

Native fx test culture dogfood (Production Complete board).

## Corpora

Staged copies under `corpus/` mirror SoT:

- `validation/reference/hexcodec_corpus.tsv`
- `validation/reference/crc32_corpus.tsv`
- `validation/reference/leb128_corpus.tsv`

## Gate

```powershell
.\scripts\test-fx-assure.ps1
```

## Convention

- Files: `*_test.fx`
- Suite members: `fn test_*`
- `main` aggregates and returns `Ok(0)` / exit 0
