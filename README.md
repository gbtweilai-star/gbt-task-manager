# task_manager

**One capability bit from GBT V8, packaged standalone.** No. 282 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 任务管理器（主人令 2026-09-27）：一屏看全「任务 / 归属 / 内存占用 / CPU / 端口 / 进程ID」；psutil 读**真进程**（CPU 需两次采样：process_iter 的 info 是首次缓存，第二遍必须直接再调）；归属按**进程名优先**认（血账：只看命令行会把 chrome 误认成框架服务）；**网络列是"占着的端口"不是流量**（本机取不到 per-process 流量，不编）；stop 过 process_execute 门；page 生成我们视觉语言的静态页（SVG 图标·无 emoji·深色+青橙）。op=list/stop/page

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-task-manager.git
cd gbt-task-manager
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_task_manager info                  # capability card
python -m gbt_task_manager spec --json           # machine-readable contract
python -m gbt_task_manager check --payload '{}'
python -m gbt_task_manager run   --payload '{}'
```

Real `info` output from this machine:

```text
task_manager  (system)  v1.0.0
----------------------------------------
任务管理器（主人令 2026-09-27）：一屏看全「任务 / 归属 / 内存占用 / CPU / 端口 / 进程ID」；psutil 读**真进程**（CPU 需两次采样：process_iter 的 info 是首次缓存，第二遍必须直接再调）；归属按**进程名优先**认（血账：只看命令行会把 chrome 误认成框架服务）；**网络列是"占着的端口"不是流量**（本机取不到 per-process 流量，不编）；stop 过 process_execute 门；page 生成我们视觉语言的静态页（SVG 图标·无 emoji·深色+青橙）。op=list/stop/page

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : list, stop, page
```

Wire a real implementation:

```python
from gbt_task_manager import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`list`、`stop`、`page`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `task_manager` |
| domain | `system` |
| handler | `task_manager` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/task_manager](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/task_manager.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
