#!/bin/bash                                                                                                                                                       
#En en el pfsense tenemos que tener creado un usuario bck con permisos de SCP y la KEY publica copiada
DIR=/home/backups/pfsense                                                                                                                                        
DATE="$(/bin/date +%d-%m-%y-%R:%S)"                                                                                                                               
USER=bck                                                                                                                                                       
LIST_FIREWALLS="IP1 IP2"                                                                                                                            
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}
for FIREWALL in $LIST_FIREWALLS 
do
        #Se valida que el parametro introducido es una IP
        if valid_ip $FIREWALL ; then
                #si el directorio no existe se creara
                if [ ! -d "$DIR/$FIREWALL/" ]; then
                        /bin/mkdir -p $DIR/$FIREWALL/
                fi
                #Se copia la configuracion via scp
                scp $USER@$FIREWALL:/conf/config.xml $DIR/$FIREWALL/$DATE-$FIREWALL.xml
        else
                echo "$FIREWALL not valid IP"
        fi
        #Se eliminan los ficheros mas antiguos de 180 dias
        /usr/bin/find $DIR/$FIREWALL/* -mtime +180 -exec rm {} \;
done
