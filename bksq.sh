# new Env('贝壳社区');
#by-莫老师，版本1.0
#青龙创建变量bksq，值为用户名@登录密码
#cron:5 0 * * *
zh=($(echo $bksq | sed 's/&/ /g'))
localip=$(curl -sk -X GET "https://ip.3322.net")
curl -sk -X GET -H "Host: service.ipzan.com" "https://service.ipzan.com/whiteList-add?no=$no&sign=$(echo -n "$pass:$key:$(date +%s)" | openssl enc -aes-128-ecb -K "$(echo -n "$aeskey" | xxd -p)" -nosalt | xxd -p | tr -d '\n')&ip=$localip" | jq -r '.data'
getip(){
tmp=$(curl -sk -X GET "https://service.ipzan.com/core-extract?num=1&no=$no&minute=3&format=json&repeat=1&protocol=3&pool=ordinary&mode=whitelist&secret=$key")
ip=$(echo ''$tmp'' | jq -r '.data.list[].ip')
port=$(echo ''$tmp'' | jq -r '.data.list[].port')
if [ -n "$ip" ]; then
export all_proxy="socks5://$ip:$port"
if [ "$(curl -sk -X GET "https://ip.3322.net")" = "$ip" ]; then
echo "###$ip:$port可用###"
else
unset all_proxy
sleep 3
echo "###$ip:$port不可用##"
getip
fi
fi
}
for s in "${!zh[@]}"; do
sleep $((60 + RANDOM % 60))
unset all_proxy
getip
IFS='@' read -r user pass <<< "${zh[$s]}"
token=$(curl -sik -X POST -H "Host: bk011.top" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "x-requested-with: XMLHttpRequest" -H "user-agent: Mozilla/5.0 (Linux; Android 13; M2102J2SC Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/116.0.0.0 Mobile Safari/537.36" -d "email=$user&password=$(echo -n "$pass" | md5sum | awk '{print $1}')" "https://bk011.top/user-login.htm" | grep -E 'bbs_token=[^;]+(?<!deleted)' | sed -E 's/.*bbs_token=([^;]+);.*/\1/')
sleep 1
curl -sk -X POST -H "Host: bk011.top" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "x-requested-with: XMLHttpRequest" -H "user-agent: Mozilla/5.0 (Linux; Android 13; M2102J2SC Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/116.0.0.0 Mobile Safari/537.36" -H "cookie: bbs_token=$token" -d "action=check" "https://bk011.top/sg_sign-list_today.htm" | jq -r '.message'
done