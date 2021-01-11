#!/bin/bash
clear

logfile=~/bin/logs/Borg_Backup_$(date +"%Y"."%m").log
export BORG_PASSPHRASE='<PASSWORD>'
export BORG_REPO='<USER>@<Server>:<PATH_TO_BORG_REPO>'

exec > >(tee -a ${logfile}) 2>&1

if [ ! -f $logfile ]; then
  touch $logfile
fi

echo ""
echo "#######################################################################################"
echo "#                                   $(date +"%Y.%m.%d %H:%M:%S ")                              #"
echo "#######################################################################################"
echo ""

borg create         \
  --filter AME      \
  --list            \
  --stats           \
  --compression lz4 \
  --show-rc         \
  ::'{hostname}_{now:%Y.%m.%d}_{now:%H:%M:%S}'  \
  ~/Folder1    \
  ~/Folder2    \
  ~/Folder3    \

errorcode=$?

if [ $errorcode -eq 0 ]; then
  echo ""
  echo "#######################################################################################"
  echo "#                  Erfolgreich: Datensicherung erfolgreich                            #"
  echo "#######################################################################################"
  echo ""
elif [ $errorcode -eq 1 ]; then
  echo ""
  echo "######################################################################################"
  echo "#              Warnung: Datensicherung wurde mit Warnungen beendet                    #"
  echo "#######################################################################################"
  echo ""
  read -p ""
else
  echo ""
  echo "#######################################################################################"
  echo "#             Fehler: Datensicherung konnte nicht durchgeführt werden!                #"
  echo "#######################################################################################"
  echo ""
  read -p ""
fi

exit $errorcode
