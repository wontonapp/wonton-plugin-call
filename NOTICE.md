# 许可和来源

插件包里的三个上游软件作为独立容器运行、不改源码：

| 软件 | 许可证 | 源码 | 版权 |
| --- | --- | --- | --- |
| Element Call（网页） | AGPL-3.0-only | https://github.com/element-hq/element-call | Element Creations Ltd. |
| lk-jwt-service（通话钥匙） | AGPL-3.0-only | https://github.com/element-hq/lk-jwt-service | Element Creations Ltd. |
| LiveKit（画面和声音转发） | Apache-2.0 | https://github.com/livekit/livekit | LiveKit, Inc. |

运行它们的镜像基于：

- `nginxinc/nginx-unprivileged`（alpine-slim 变体）：nginx，BSD-2-Clause，https://nginx.org/LICENSE ；Alpine Linux 及其软件包，各自的上游许可。
- `livekit/livekit-server`：Alpine 基底，许可同上。

AGPL-3.0 全文见 https://www.gnu.org/licenses/agpl-3.0.txt ，Apache-2.0 全文见 https://www.apache.org/licenses/LICENSE-2.0 。

插件包自己（docker-compose.yml、call-nginx.conf、call-config.json、icon.svg、本文件）以 MIT 提供，见本仓库的 LICENSE；包里不含上游代码，上游软件按各自许可作为独立容器运行。
