#!/bin/bash
clear

while pgrep -x borg; do
  # Wenn borg läuft soll 120 sekunden gewartet werden
  sleep 120
done
# Weiter wenn Prozess borg nicht gefunden wurde

logfile=~/bin/log/borg_prune.log
export BORG_REPO='<PATH_TO_BORG_REPO>'
export BORG_PASSPHRASE='<PASSWORD>'
prefix="<FIRST_LETTER_OF_BACKUP_PREFIX>*"

#In Syslog schreiben
exec > >(tee -a ${logfile}) 2>&1

echo ""
echo "###################################################################################################"
echo "#                                         $(date +"%Y.%m.%d-%H:%M:%S ")                                    #"
echo "###################################################################################################"
echo ""

borg prune --list --prefix $prefix --keep-daily 7 --keep-weekly 2 --keep-monthly 3

errorcode=$?

if [ $errorcode -eq 0 ]; then
  echo ""
  echo "###################################################################################################"
  echo "#                        Erfolgreich: Prunning erfolgreich                                        #"
  echo "###################################################################################################"
  echo ""
elif [ $errorcode -eq 1 ]; then
  echo ""
  echo "###################################################################################################"
  echo "#                    Warnung: Prunning wurde mit Warnungen beendet                                #"
  echo "###################################################################################################"
  echo ""
else
  echo ""
  echo "###################################################################################################"
  echo "#                   Fehler: Prunning konnte nicht durchgeführt werden!                            #"
  echo "###################################################################################################"
  echo ""
fi

exit $errorcode
