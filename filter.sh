[ -z $1 ] || [ -z $2 ] && echo "Usage: $0 <username> <password>" && exit 1
TOKEN=`http post http://localhost/api/login username="$1" password="$2" | jq -r .token`
FILTER=`cat input.json | jq -c | cat| base64 -w 0`
DEVICES=`http get  http://localhost/api/devices?filter=$FILTER "Authorization: Bearer $TOKEN"`
echo "$DEVICES"

