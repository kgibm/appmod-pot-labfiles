######################
#  build-container.sh 
######################

## No input parameters required to run this script. 
## -i  If you want to run the commands in the script by being prompted to continue
## exmple: build-container.sh -i

numParms=$#
parm1=$1

#echo "numparms: $numParms"
#echo "parm 1: $1"

if [ $numParms != 0 ]; then
#  echo "numParms > 0, have parms"
  if [ $1 == "-i" ]; then
#    echo "parm1 is '-i"
    INTERACTIVE_MODE="true"
    echo ""
    echo "---------------------------------------------"
    echo "    Script is running in interactive mode! "
    echo "---------------------------------------------"
    echo ""
    sleep 5
  fi 
fi


STUDENT_LAB_DIR="/home/techzone/Student/labs/appmod"
STUDENT_PBW_BUNDLE="/home/techzone/Student/labs/appmod/pbw-bundle-complete"
PWD=pwd
LOGS=$STUDENT_LAB_DIR/logs
LOG=$STUDENT_LAB_DIR/logs/build-container.log

#create the LOGS directory if it does not exist
if [ ! -d "$LOGS" ]; then
     mkdir $LOGS ;
     echo "Create Logs Directory: $LOGS"
fi

#Remove the old log if it exists
if [  -f "$LOG" ]; then
    rm $LOG ;
    echo "removed $LOG"
fi


cd $STUDENT_PBW_BUNDLE

echo ""
echo "-> working directory: $PWD" | tee $LOG
echo ""
# Cleanup any existing components


# if db2 is running, check if its connected to pbw network
# if it is, disconnect from the network, then stop the db
#
echo ""
echo "----------------------"
echo "Running cleanup steps" 
echo "----------------------"


cmd1=$(docker images | grep apps/pbw )
#echo "cmd1: $cmd1"

if [ -n "$cmd1" ]; then
  echo "-> pbw docker image exists, remove it now"
  echo "   -> removing pbw docker image"
  docker rmi apps/pbw:latest > /dev/null 2>&1
  echo "   ->  apps/pbw docker image removed"
  sleep 2
fi

echo "----------------------"
echo "End of cleanup steps"
echo "----------------------"

sleep 2


#build the container


echo ""
echo "=======================================" | tee -a $LOG
echo "Setup, Build, and Run the PBW container" | tee -a $LOG
echo "=======================================" | tee -a $LOG
echo ""

echo ""
echo "==========================================="
echo "1. Build and tag the 'PlantsByWebSphere' application container image"
echo "--------------------------------------------------"
echo " " | tee -a $LOG
echo "   1. ---> docker build -f $STUDENT_PBW_BUNDLE/Containerfile --tag apps/pbw ." | tee -a $LOG
echo " " | tee -a $LOG
 echo "--------------------------------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker build -f $STUDENT_PBW_BUNDLE/Containerfile --tag apps/pbw .

echo "================================" | tee -a $LOG
echo "build-container script completed" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "" | tee -a $LOG

exit 0
