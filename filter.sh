translate_filter(){
    echo "aaa"
    declare -a arr
    echo $1
operands=`echo $1| sed 's/\(.*\)\,{\"type\":\"operator\"\,\"operator_params\":{\"name\":\"\(.*\)\"}}\(.*\)/\1/'`
operator=`echo $1 | sed 's/\(.*\)\,{\"type\":\"operator\"\,\"operator_params\":{\"name\":\"\(.*\)\"}}\(.*\)/\2/'`

echo "OPERANDS $operands"
echo "OPERATOR $operator"

if [[ $operator == "and" ]] || [[ $operador == "or" ]] || [[ $operands == $operator  ]]
then
    echo "soon"
    #echo $operands
    translate_filter "$operands"
    #echo "soon"
fi;
#echo $operands| jq -c '.[].property_params' | while read i; do
while read -r i ; do
    #echo $i
    [[ $i == null ]] && break

    EXAMPLE=`echo "[{\"uid\":\"e527be96a5a4e4fde429adbc01ae8ad490064acd0e5972444638fee61c347853\",\"name\":\"1c-69-7a-05-7f-66\",\"identity\":{\"mac\":\"1c:69:7a:05:7f:66\"},\"info\":{\"id\":\"arch\",\"pretty_name\":\"Arch Linux\",\"version\":\"latest\"},\"public_key\":\"-----BEGIN RSA PUBLIC KEY-----\nMIIBCgKCAQEAv05IqJgdW+EBndjgMbSArddqK8lBoNaPtdrZGEpE0SxlCXsbAazJ\ngDuh4PrzauZXq85G/GxgCiEmj8168rKMV5GkiwyD1ztyybuqT5aIzQp+4tchUo47\ntLfxgNUyPslrEzv3LHwUfwhQfuilOoCqiDSXJZ2QsqGMypLUnUpdLbN6UA+7H+RC\nfV0710cA81jknrdls51HvMt9pXTGChGorB8dpl55Ghn4u6tRPMJLDjg+RVBfAe2w\nqpiuyBPz0gqnUVH2UuTCoTls/t90EiwPgvh6FOcE0uaEX+CVrPIAXG9SkicoWAGl\nUyLHXg+6mw7/DplMUl8ZBHHfKYHPTG/iKwIDAQAB\n-----END RSA PUBLIC KEY-----\n\",\"tenant_id\":\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\",\"last_seen\":\"2020-05-26T16:24:03.586Z\",\"online\":true,\"namespace\":\"edu\"},{\"uid\":\"9bb75355f5bfb85903e02e39632c0a5f79df46e82e0a5d10bbc8e8a7e2f278cb\",\"name\":\"02-b0-26-32-4c-69\",\"identity\":{\"mac\":\"02:b0:26:32:4c:69\"},\"info\":{\"id\":\"debian\",\"pretty_name\":\"debian\",\"version\":\"latest\"},\"public_key\":\"-----BEGIN PUBLIC KEY----- MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzRZQ2bLrfjb/MH6NT/E+ PUWgxxRgc2Bm19tQWTEHWIQ+8Si1Cyg2fQlP7/GcZqDlqwrgks4VNAeIP42jEuXq ksIjewTzKeHG3lEqDYfjyWY9dJlYiuAMBloYEqjE3Fjpr58qICmYhYMNzuXw/NT8 0hMrazgqw8INXFfM3SS1VODWxjCo2tS3s+dvJSBjb+6UOi2gsOJ6b/Ks8VOv8TK0 3Y3tYRLFptLJvkHjJ4E0VzF8C5gqRmdXm7xIaOhqB8o5T4VypTkKS64wfbLgrWZc /6t18y/TL3BfJMEivK4Y9i0Ufh5+vAlT/6joVTbNDtoQhcbiQnVH1sW6xds+Hqgu IQIDAQAB -----END PUBLIC KEY-----\n\",\"tenant_id\":\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\",\"last_seen\":\"2020-05-26T16:11:15.743Z\",\"online\":false,\"namespace\":\"edu\"}]"`



  #if [[ `echo $i | jq -c -r -e '.operator'` == "eq" ]] ;then
   #   name=`echo $i| jq -c -r .name`
    #  value=`echo $i | jq -c -r .value`
    #   arr+=(".$name == \"$value\"")

  # fi;
done < <(echo $operands| jq -c -r -e 'reverse |.[].property_params' )  
echo ${arr[*]}

#FILTERED_DEVICES=`http get  http://localhost/api/devices?filter=$FILTER "Authorization: Bearer $TOKEN"`
#echo "$DEVICES"

}


#TOKEN=`http post --ignore-stdin http://localhost/api/login username="$1" password="$2" | jq -r .token`
#FILTER=`cat -  | jq -c | cat | base64 -w 0`
#DEVICES=``
JASON="[{\"type\": \"property\", \"property_params\": {\"name\": \"info.id\",  \"operator\": \"eq\",  \"value\": \"arch\"}},{\"type\": \"property\", \"property_params\": {\"name\": \"info.id\",  \"operator\": \"eq\",  \"value\": \"debian\"}},{\"type\":\"operator\",\"operator_params\": {\"name\": \"or\"}},{\"type\": \"property\", \"property_params\": {\"name\": \"info.id\",  \"operator\": \"name\",  \"value\": \"merda\"}},{\"type\":\"operator\",\"operator_params\":{\"name\":\"and\"}}]"
echo $JASON | jq -c '.'
#jason=`echo $JASON | jq -c '.'`
#echo $JASON
translate_filter "$JASON"
#echo $JASON | jq 'reverse'
