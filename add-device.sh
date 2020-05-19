for i in `seq $1`
do
    TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    MACADDR=$(echo $RANDOM|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02-\1-\2-\3-\4-\5/')
    NAME=$MACADDR
    UID_VALUE=$(echo $RANDOM | shasum -a 256| cut -d" " -f1)
    INSERTED=`docker-compose exec -T mongo mongo main --quiet --eval "db.devices.insert({ uid: '$UID_VALUE', name: '$NAME', tenant_id: '$TENANT_ID' }).nInserted"`

    if [ $INSERTED -eq 1 ]; then
	echo "Device added: $NAME"
    else
	echo "ERROR: Failed to add device"
    fi
done
