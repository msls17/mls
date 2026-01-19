# new Env('贝壳社区');
#by-莫老师，版本1.1
#青龙创建变量bksq，值为用户名@登录密码
#cron:35 10 * * *
zh=($(echo $bksq | sed 's/&/ /g'))
url=bk020.top
IFS='@' read -r pzphone pass aeskey no key userid <<< "$pinz"
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
sleep $((600 + RANDOM % 600))
unset all_proxy
getip
IFS='@' read -r user pass <<< "${zh[$s]}"
token=$(curl -sik -X POST -H "Host: $url" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "x-requested-with: XMLHttpRequest" -H "user-agent: Mozilla/5.0 (Linux; Android 13; M2102J2SC Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/116.0.0.0 Mobile Safari/537.36" -d "email=$user&password=$(echo -n "$pass" | md5sum | awk '{print $1}')" "https://$url/user-login.htm" | grep 'bbs_token=' | grep -v 'bbs_token=deleted' | sed -E 's/.*bbs_token=([^;]+);.*/\1/')
sleep $((10 + RANDOM % 50))
curl -sk -X POST -H "Host: $url" -H "content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "x-requested-with: XMLHttpRequest" -H "user-agent: Mozilla/5.0 (Linux; Android 13; M2102J2SC Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/116.0.0.0 Mobile Safari/537.36" -H "cookie: bbs_token=$token" -d "action=check" "https://$url/sg_sign-list_today.htm"
done