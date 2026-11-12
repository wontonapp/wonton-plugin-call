# 通话插件（Element Call）

给 [Wonton](https://github.com/wontonapp/wonton) 装视频通话用的插件：家人在 App 聊天房间的顶栏点通话按钮，就能互相打视频电话。形态按 [ADR-0096](https://github.com/wontonapp/wonton/blob/main/docs/adr/0096-calls-matrixrtc-widget.md)（MatrixRTC + LiveKit，Element Call 网页作为 Matrix widget 跑在插件页里）。

## 结构

| 服务 | 镜像（固定摘要） | 许可证 | 作用 |
| --- | --- | --- | --- |
| `livekit` | `livekit/livekit-server:v1.13.11@sha256:25cd902d…` | Apache-2.0 | 转发画面和声音。`rtc.node_ip: 127.0.0.1`、UDP mux 7882、TCP 7881、房间不自动建 |
| `jwt` | `ghcr.io/element-hq/lk-jwt-service:0.9.0@sha256:d210fd77…` | AGPL-3.0 | MSC4195 授权服务：验 Matrix OpenID 令牌换 LiveKit 令牌，代管断线后的 delayed leave（独立模式） |
| `web` | `ghcr.io/element-hq/element-call:v0.28.2@sha256:c61fc9e4…` | AGPL-3.0 | Element Call 网页，插件的网页入口；同一入口把 `/livekit/sfu` 反代到 `livekit:7880` |

- 信令和授权都走标准地址，不开额外端口：页面同源的 `/livekit/sfu`（`call-nginx.conf`），和 Matrix 对外地址下的 `/_wonton/matrix-rtc`（清单 `provides.matrix_rtc`，由核心转发）。
- 媒体端口经清单 `tunnel.ports` 映射到手机本机同号端口（ADR-0072）：UDP 7882、TCP 7881。7880 只在插件网络里。
- Element Call 的运行配置 `call-config.json` 不配任何遥测（posthog、sentry、rageshake 都不设）。
- LiveKit 的 API 密钥来自清单 `secrets`（核心生成、只注入给用到的容器）。
- 许可和来源见 [NOTICE.md](NOTICE.md)；插件包自身以 MIT 提供（见 [LICENSE](LICENSE)），上游软件按各自许可作为独立容器运行。

## 校验

```sh
wonton-core plugin check <本目录> --official
```

`matrix_widget` 字段按 wontonapp/wonton#407 的实现写，`plugin check` 要用含 #407 的核心构建（spec 0.14 的 `matrix_widget`）。
