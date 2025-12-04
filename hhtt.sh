# new Env('和合天台');
#by-莫老师，版本1.0
#青龙创建变量hhtt，值为手机号@登录密码
#cron:47 11 * * *
#下载地址：https://app.ttcmzx.cn/webChannels/invite?inviteCode=EYWX6S&tenantId=5&accountId=692abcd3a95d5a224ab2717d
zh=($(echo $hhtt | sed 's/&/ /g'))
url=vapp.tmuyun.com
getsign(){
IFS='?' read -r l c <<< "$u"
t=$(date '+%s%3N')
d="$(uuidgen)"
s=$(echo -n ''$l'&&'$e'&&'$d'&&'$t'&&FR*r!isE5W&&5' | sha256sum | awk '{print $1}')
}
g(){
getsign
tmp=$(curl -sk -X GET -H "X-SESSION-ID: $e" -H "X-REQUEST-ID: $d" -H "X-TIMESTAMP: $t" -H "X-SIGNATURE: $s" -H "X-TENANT-ID: 5" -H "User-Agent: 4.5.8;00000000-6641-8460-0000-0000723f160a;Xiaomi M2102J2SC;Android;13;huawei;6.8.0" -H "X-ACCOUNT-ID: $a" -H "Host: $url" "https://$url$u")
sleep $((3 + RANDOM % 3))
}
p(){
getsign
tmp=$(curl -sk -X POST -H "X-SESSION-ID: $e" -H "X-REQUEST-ID: $d" -H "X-TIMESTAMP: $t" -H "X-SIGNATURE: $s" -H "X-TENANT-ID: 5" -H "User-Agent: 4.5.8;00000000-6641-8460-0000-0000723f160a;Xiaomi M2102J2SC;Android;13;xiaomi;6.8.0" -H "Content-Type: application/x-www-form-urlencoded" -H "Host: $url" -H "X-ACCOUNT-ID: $a" -d "$b" "https://$url$u")
sleep $((3 + RANDOM % 3))
}
m(){
jq -r '.message' <<< "$tmp"
}
yy(){
IFS=',' read -r title content <<< "$(curl -sk http://ililil.cn:88/api/yy.php)"
if [ -z "$content" ]; then
title=莫老师
content=那也太帅了吧
fi
}
for z in "${!zh[@]}"; do
IFS='@' read -r phone pass <<< "${zh[$z]}"
u=/api/account/init
b=""
p
e=$(jq -r '.data.session.id' <<< "$tmp")
u=/web/oauth/credential_auth
code=$(curl -sk -X POST -H "User-Agent: ANDROID;13;10;4.5.8;1.0;null;M2102J2SC" -H "X-REQUEST-ID: $d" -H "X-SIGNATURE: $s" -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -H "Host: passport.tmuyun.com" -d "client_id=10&password=$(echo -n "$pass" | openssl pkeyutl -encrypt -pubin -inkey <(echo "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD6XO7e9YeAOs+cFqwa7ETJ+WXizPqQeXv68i5vqw9pFREsrqiBTRcg7wB0RIp3rJkDpaeVJLsZqYm5TW7FWx/iOiXFc+zCPvaKZric2dXCw27EvlH5rq+zwIPDAJHGAfnn1nmQH7wR3PCatEIb8pz5GFlTHMlluw4ZYmnOwg+thwIDAQAB" | base64 -d | openssl rsa -pubin -inform DER -outform PEM 2>/dev/null) -pkeyopt rsa_padding_mode:pkcs1 | base64 -w 0 | tr -d '\n' | jq -sRr @uri)&phone_number=$phone" "https://passport.tmuyun.com$u" | jq -r '.data.authorization_code.code')
u=/api/zbtxz/login
b="check_token=&code=$code&token=&type=-1&union_id="
p
e=$(jq -r '.data.session.id' <<< "$tmp")
a=$(jq -r '.data.session.account_id' <<< "$tmp")
u=/api/user_mumber/sign
g
echo "签到积分$(jq -r '.data.signIntegral' <<< "$tmp")"
u=/api/user_mumber/doTask
b="memberType=6&member_type=6"
p
m
u="/api/article/channel_list?channel_id=5bf216941b011b0880b6e49f&isDiFangHao=false&is_new=true&list_count=20&size=20"
g
ids=($(jq -r '.data.article_list[].id' <<< "$tmp"))
u="/api/bbs/api/post/list?categoryId=504"
g
ttids=($(jq -r '.data.records[].id' <<< "$tmp"))
for x in $(seq 3); do
u=/api/article/detail?id=${ids[$x]}
g
m
yy
u=/api/comment/create/v2
getsign
tmp=$(curl -sk -X POST -H "X-SESSION-ID: $e" -H "X-REQUEST-ID: $d" -H "X-TIMESTAMP: $t" -H "X-SIGNATURE: $s" -H "X-TENANT-ID: 5" -H "User-Agent: 4.5.8;00000000-6641-8460-0000-0000723f160a;Xiaomi M2102J2SC;Android;13;xiaomi;6.8.0" -H "Content-Type: application/json; charset=utf-8" -H "Host: $url" -d '{"channel_article_id":"'${ids[$x]}'","content":"'$content'"}' "https://$url$u")
m
u=/api/favorite/like
b="action=true&id=${ids[$x]}"
p
m
u=/api/user_mumber/doTask
b="memberType=3&member_type=3&target_id=${ids[$x]}"
p
m
u="/api/bbs/api/post/zan?id=${ttids[$x]}&status=1"
g
m
u="/api/bbs/api/post/share?id=${ttids[$x]}"
g
m
yy
u="/api/bbs/api/reply/edit"
b="content=$content&postId=${ttids[$x]}"
p
m
done
for x in $(seq 2); do
yy
u="/api/bbs/api/post/save"
b="auditStatus=0&categoryId=505&content=%3Cp%20style%3D%22margin%3A0px%22%3E$content%3C%2Fp%3E%0A&postType=4&subjectId=227466&topicTitleList=&videoTime=0"
p
m
done
u="/api/user_mumber/numberCenter?is_new=1"
g
echo "账号$phone当前积分$(jq -r '.data.rst.total_integral' <<< "$tmp")"
done