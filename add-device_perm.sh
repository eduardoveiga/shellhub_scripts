insert() {
TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
MACADDR=$(echo $RANDOM|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02-\1-\2-\3-\4-\5/')
UID_VALUE=$(echo $RANDOM | shasum -a 256| cut -d" " -f1)
INSERTED=`docker-compose exec -T mongo mongo main --quiet --eval "db.devices.insert({ uid: '$UID_VALUE', name: '$out', tenant_id: '$TENANT_ID' }).nInserted"`

if [ $INSERTED -eq 1 ]; then
    echo "Device added: $out"
else
    echo "ERROR: Failed to add device"
fi

}
perm() {
  local items="$1"
  local out="$2"
  local i
  [[ "$items" == "" ]]  && insert "$out" && return
  for (( i=0; i<${#items}; i++ )) ; do
    perm "${items:0:i}${items:i+1}" "$out${items:i:1}"
  done
}
perm "$1" 
