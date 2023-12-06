#!/usr/bin/env zsh

# https://github.com/ACL4SSR/ACL4SSR.git
# https://raw.gitmirror.com/ACL4SSR/ACL4SSR/master/Clash/Ruleset/360.list

# mkdir -p '.cache/acl4ssr'
# git clone -b master 'https://github.com/ACL4SSR/ACL4SSR.git'

# mkdir -p './.cache/'
# curl -o './.cache/360.list' -L https://raw.gitmirror.com/ACL4SSR/ACL4SSR/master/Clash/Ruleset/360.list
# curl -o './.cache/360.list' -L https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/LocalAreaNetwork.list

alias curl="curl -s"

GIT_ORIGINAL='https://raw.githubusercontent.com'
GIT_MIRROR='https://raw.gitmirror.com'
GIT="$GIT_MIRROR"

ACL4SSR="ACL4SSR/ACL4SSR/master"

YAML_HEADER="---\n# Update: $(date "+%Y-%m-%d %H:%M:%S")\npayload:"
RULES_DIR="rules"
mkdir -p $RULES_DIR

tmp_cache=`mktemp -d`

print "\033[32m[开始更新]\033[0m"


LABEL() {
  if [[ '当前规则' == $1 ]]; then
    print "\033[s\033[33m$1: \033[0m$2"
  else
    print "\033[s\033[36m$1: \033[0m$2"
  fi
}


acl4ssr() {
  local rule_file="$1"
  local FILE_LIST=(${@:2})

  print `LABEL 更新规则 $rule_file`

  echo "$YAML_HEADER" > $rule_file
  for FILE_PATH in ${FILE_LIST};do
    local url="$GIT/$FILE_PATH"
    local str="\033[K$(LABEL 正在下载 $url)"

    echo -e -n "$str\033[${#str}D"

    echo "  # [Source: $url]" >>$rule_file
    curl $url | awk '{print "  - " $0}' >>$rule_file
  done
  echo -e -n "\033[u\033[k\033[0m"
}

# ------------------------
# Chinese IPv4 and IPv6
# ------------------------
rule_file="$RULES_DIR/china-ips"

print "\033[s$(LABEL 当前规则 "$rule_file")"
print `LABEL 正在下载 "https://ftp.apnic.net/stats/apnic/delegated-apnic-latest"`

curl -o "$tmp_cache/delegated-apnic-latest.txt" 'https://ftp.apnic.net/stats/apnic/delegated-apnic-latest'

if [[ -f "$tmp_cache/delegated-apnic-latest.txt" ]]; then
  echo "$YAML_HEADER" > $rule_file
  cat  "$tmp_cache/delegated-apnic-latest.txt" | awk -F '|' '/CN/&&/ipv6/ {print "  - IP-CIDR6," $4 "/" $5 ",no-resolve"}' | cat >>$rule_file
  cat  "$tmp_cache/delegated-apnic-latest.txt" | awk -F '|' '/CN/&&/ipv4/ {print  "  - IP-CIDR," $4 "/" 32-log($5)/log(2) ",no-resolve"}'  | cat >>$rule_file
fi


# apple
source_list=(
  $ACL4SSR/Clash/Ruleset/Apple.list
  $ACL4SSR/Clash/Ruleset/AppleNews.list
  $ACL4SSR/Clash/Ruleset/AppleTV.list
)
acl4ssr "$RULES_DIR/apple" $source_list

# google
source_list=(
  $ACL4SSR/Clash/Ruleset/Google.list
  $ACL4SSR/Clash/Ruleset/GoogleCN.list
  $ACL4SSR/Clash/Ruleset/GoogleCNProxyIP.list
  $ACL4SSR/Clash/Ruleset/GoogleEarth.list
  $ACL4SSR/Clash/Ruleset/GoogleFCM.list
  $ACL4SSR/Clash/Ruleset/YouTube.list
  $ACL4SSR/Clash/Ruleset/YouTubeMusic.list
)
acl4ssr "$RULES_DIR/google" $source_list

# twitter
source_list=(
  $ACL4SSR/Clash/Ruleset/Twitter.list
)
acl4ssr "$RULES_DIR/twitter" $source_list

# telegram
source_list=(
  $ACL4SSR/Clash/Ruleset/Telegram.list
)
acl4ssr "$RULES_DIR/telegram" $source_list

# LocalAreaNetwork
source_list=(
  $ACL4SSR/Clash/LocalAreaNetwork.list
)
acl4ssr "$RULES_DIR/local-area-network" $source_list

# ProxyGFWlist
source_list=(
  $ACL4SSR/Clash/ProxyGFWlist.list
)
acl4ssr "$RULES_DIR/gfw" $source_list

# Chine Co, Ltd.
source_list=(
  $ACL4SSR/Clash/Ruleset/360.list
  $ACL4SSR/Clash/Ruleset/58.list
  $ACL4SSR/Clash/Ruleset/Alibaba.list
  $ACL4SSR/Clash/Ruleset/Baidu.list
  $ACL4SSR/Clash/Ruleset/Bilibili.list
  $ACL4SSR/Clash/Ruleset/BilibiliHMT.list
  $ACL4SSR/Clash/Ruleset/ByteDance.list
  $ACL4SSR/Clash/Ruleset/CCTV.list
  $ACL4SSR/Clash/Ruleset/CN.list
  $ACL4SSR/Clash/Ruleset/ChinaDNS.list
  $ACL4SSR/Clash/Ruleset/ChinaNet.list
  $ACL4SSR/Clash/Ruleset/DiDi.list
  $ACL4SSR/Clash/Ruleset/Douyu.list
  $ACL4SSR/Clash/Ruleset/Dubox.list
  $ACL4SSR/Clash/Ruleset/ITV.list
  $ACL4SSR/Clash/Ruleset/Iqiyi.list
  $ACL4SSR/Clash/Ruleset/IqiyiHMT.list
  $ACL4SSR/Clash/Ruleset/JD.list
  $ACL4SSR/Clash/Ruleset/JOOX.list
  $ACL4SSR/Clash/Ruleset/KKBOX.list
  $ACL4SSR/Clash/Ruleset/KKTV.list
  $ACL4SSR/Clash/Ruleset/KakaoTalk.list
  $ACL4SSR/Clash/Ruleset/Kingsoft.list
  $ACL4SSR/Clash/Ruleset/LeTV.list
  $ACL4SSR/Clash/Ruleset/LiTV.list
  $ACL4SSR/Clash/Ruleset/MI.list
  $ACL4SSR/Clash/Ruleset/MIUIPrivacy.list
  $ACL4SSR/Clash/Ruleset/Meitu.list
  $ACL4SSR/Clash/Ruleset/NetEase.list
  $ACL4SSR/Clash/Ruleset/NetEaseMusic.list
  $ACL4SSR/Clash/Ruleset/PDD.list
  $ACL4SSR/Clash/Ruleset/PPTVPPLive.list
  $ACL4SSR/Clash/Ruleset/PublicDirectCDN.list
  $ACL4SSR/Clash/Ruleset/Sina.list
  $ACL4SSR/Clash/Ruleset/SohuSogo.list
  $ACL4SSR/Clash/Ruleset/Tencent.list
  $ACL4SSR/Clash/Ruleset/TencentLolm.list
  $ACL4SSR/Clash/Ruleset/TencentVideo.list
  $ACL4SSR/Clash/Ruleset/Xunlei.list
  $ACL4SSR/Clash/Ruleset/YYeTs.list
  $ACL4SSR/Clash/Ruleset/Youku.list
)
acl4ssr "$RULES_DIR/china-co-ltd" $source_list


# echo -e -n "\033[u\033[K\033[1A\033[K"
print "\033[32m[更新完成]\033[0m"
