[ -z $1 ] || [ -z $2 ] && echo "Usage: $0 <number> <username> <password>" && exit 1
#add device
for i in `seq $1`
do
    TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ID=$(echo "raspbian ubuntucore arch debian ubuntu" | cut -d' ' -f$(shuf -i1-5 -n1))
    PRETTY_NAME=$ID
    MACADDR=$(echo $FQDN$i|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')
    NAME=$(echo $MACADDR| tr : -)
    UID_VALUE=$(echo $FQDN$i | shasum -a 256| cut -d" " -f1)


PRIVATE_KEY_FILE=$(mktemp -u)
PUBLIC_KEY_FILE=$(mktemp -u)

openssl genrsa -out $PRIVATE_KEY_FILE 2048 2> /dev/null
openssl rsa -in $PRIVATE_KEY_FILE -out $PUBLIC_KEY_FILE -pubout 2> /dev/null

PUBLIC_KEY=$(cat $PUBLIC_KEY_FILE)

rm -f $PRIVATE_KEY_FILE
rm -f $PUBLIC_KEY_FILE

JSON=`echo "{
  uid: '$UID_VALUE', 
  name:'$NAME',
  info: {
    id: '$ID',
    pretty_name: '$PRETTY_NAME',
    version: 'latest'
  },
  identity: {
    mac: '$MACADDR'
  },
  tenant_id: '$TENANT_ID'
}"`
#(echo $JSON | http --headers post http://localhost/api/devices/auth | grep 200 && echo "Device added!") || exit 1
INSERTED=`docker-compose exec -T mongo mongo main --quiet --eval "db.devices.insert($JSON).nInserted"`
if [ $INSERTED -eq 1 ]; then
	echo "Device added: $NAME"
    else
	echo "ERROR: Failed to add device"
    fi
done


#list devices


TOKEN=`http post http://localhost/api/login username="$2" password="$3" | jq -r .token`
DEVICES=`http get  http://localhost/api/devices "Authorization: Bearer $TOKEN" | jq -c '.[].identity.mac'`

for i in `seq $1`
do
    MACADDR=$(echo $FQDN$i|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')
    [[ $DEVICES =~ $MACADDR ]] || ( echo "FAILED: $MACADDR">&2; exit 1 ) || exit 1
done
echo "PASS: List devices"

#rename device
for i in `seq $1`
do

    UID_VALUE=$(echo $FQDN$i | shasum -a 256| cut -d" " -f1)
    MACADDR=$(echo $RANDOM$i |md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02-\1-\2-\3-\4-\5/')
    RENAMED=`http --headers patch  http://localhost/api/devices/$UID_VALUE name=$MACADDR "Authorization: Bearer $TOKEN"| grep 200`
    [[ $RENAMED ]] ||  ( echo "FAILED to rename: $MACADDR">&2; exit 1 ) || exit 1
done

echo "PASS: rename devices"




#getdevice
for i in `seq $1`
do
    UID_VALUE=$(echo $FQDN$i | shasum -a 256| cut -d" " -f1)
    DEVICE=`http get  http://localhost/api/devices/$UID_VALUE  "Authorization: Bearer $TOKEN"`
    [[ $DEVICE ]] ||  ( echo "FAILED to delete: $MACADDR">&2; exit 1 ) || exit 1
done
    
echo "PASS: get devices"
#delete device

for i in `seq $1`
do

    UID_VALUE=$(echo $FQDN$i | shasum -a 256| cut -d" " -f1)
    DELETED=`http --headers delete  http://localhost/api/devices/$UID_VALUE name=$MACADDR "Authorization: Bearer $TOKEN"| grep 200`
    [[ $DELETED ]] ||  ( echo "FAILED to delete: $MACADDR">&2; exit 1 ) || exit 1
done


echo "PASS: delete devices"


#list devices
