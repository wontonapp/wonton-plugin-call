# 家庭视频通话（Element Call）

和家人打视频电话，像微信视频一样：在家里 App 的聊天房间顶上点一下通话按钮，画面和声音就通上。画面和声音都走家里自己的服务器，不经过外面的平台。

开发流程见[插件开发指南](https://github.com/wontonapp/wonton-docs/blob/main/develop.md)，清单字段以[插件规范](https://github.com/wontonapp/wonton-docs/blob/main/plugin-spec.md)为准。

## 怎么用

1. 安装插件，等它装完。
2. 打开任意一个聊天房间，点顶栏的通话按钮；第一次会问一次摄像头和麦克风的使用许可。
3. 对面的人在同一房间点通话按钮就进来了。挂断点页面里的红色按钮。

人不在家也能打，前提是家里服务器开了外网访问。页面里有一份通话成员列表，谁在通话里一眼能看到。

## 通话是怎么通起来的

装的是三个现成的开源软件，各管一段：

- 网页是 [Element Call](https://github.com/element-hq/element-call)（AGPL-3.0）：拨号、成员、挂断这些都在它的页面里。
- 画面和声音由 [LiveKit](https://github.com/livekit/livekit)（Apache-2.0）在家里转发，不落盘。
- 通话钥匙由 [lk-jwt-service](https://github.com/element-hq/lk-jwt-service)（AGPL-3.0）按登录身份发放，别人拿不到。

网页和信令走 App 的同一个地址，不用另开端口；画面和声音的两个端口只在通话时映射到配对的手机上，挂了就撤。加密房间里通话的媒体密钥只发给通话中的人。

## 数据在哪

通话本身不存录像，聊天记录还在原来的房间里。插件自己的通话密钥由云吞生成保管，升级、重装都沿用；卸载时选择删除数据才清掉。

## 已知限制

- 在云吞 App 里打，不在系统浏览器里打。
- 手机屏幕锁上或 App 退到后台太久，通话会断；回来再拨一次。
- iPhone 上还没实测过。
- 屏幕共享这一版没做。

## 文件

| 路径 | 内容 |
| --- | --- |
| `docker-compose.yml` | 插件本身：三个服务、清单、隧道端口和通话服务器地址 |
| `call-nginx.conf` | 网页入口的 nginx 配置，把信令反代给 LiveKit |
| `call-config.json` | Element Call 的运行配置 |
| `icon.svg` | 插件图标 |
| `scripts/check.sh` | 检查插件包，规则和安装时一样 |
| `scripts/dev.sh` | 开发环境：起一套云吞，装、重装、卸载插件，看日志 |

## 图标

`icon.svg` 为本仓库原创的简笔图标，按本仓库 MIT 许可证分发，见 [NOTICE](NOTICE)。
