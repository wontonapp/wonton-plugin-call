# shellcheck shell=bash
# scripts/smoke.sh 的插件探针。Element Call 是 Matrix widget 页：它认人靠 widget 桥换的 OpenID，
# URL 里的 userId 由 App 填，冒烟没有 widget 桥，所以身份项记 N/A；网页自己和通话服务的通路照常探。
export SMOKE_NOTE="Element Call 是 widget 页，身份经 widget 桥确认，冒烟里没有桥；网页、信令反代和网页配置照常探测"
export IDENTITY_NA=1
export DATA_NA=1

web_assert() { # 页面是 Element Call 自己的页面
  grep -qi 'element call' || { echo "不是 Element Call 的页面：$(head -c 200)"; return 1; }
}

extra_check() {
  local body
  # 信令和网页同源：反向代理必须真的到了 LiveKit。节点统计就绪前 / 回 406 Not Ready，也算到了。
  body="$(dweb /livekit/sfu/)" || { extra_item FAIL SFU 反代 "请求失败：$(head -c 200 <<<"$body")"; return; }
  if grep -qE '^(OK|Not Ready)' <<<"$body"; then
    extra_item PASS SFU 反代 "回的是 LiveKit 自己的就绪检查：$(head -c 40 <<<"$body")"
  else
    extra_item FAIL SFU 反代 "反代没到 LiveKit：$(head -c 200 <<<"$body")"
  fi
  # 运行时配置由插件包提供，空对象也要是合法 JSON。
  body="$(dweb /config.json)" || { extra_item FAIL 网页配置 "请求失败：$(head -c 200 <<<"$body")"; return; }
  if jq -e 'type == "object"' >/dev/null 2>&1 <<<"$body"; then
    extra_item PASS 网页配置 "config.json 是 JSON 对象"
  else
    extra_item FAIL 网页配置 "config.json 不是 JSON 对象：$(head -c 200 <<<"$body")"
  fi
  # widget 入口是 App 打开的那个地址，SPA 路由回同一个页面。
  body="$(dweb "/room?widgetId=probe&roomId=%21probe%3Aexample.org&userId=%40probe%3Aexample.org&deviceId=PROBE&baseUrl=https%3A%2F%2Fexample.org&intent=join_existing")" ||
    { extra_item FAIL widget 入口 "请求失败：$(head -c 200 <<<"$body")"; return; }
  if grep -qi 'element call' <<<"$body"; then
    extra_item PASS widget 入口 "widget 地址回的是页面"
  else
    extra_item FAIL widget 入口 "widget 地址没回页面：$(head -c 200 <<<"$body")"
  fi
}
