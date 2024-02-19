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


sleep 2

#stop the pbw container, if running
echo "-> Esnure pbw application is stopped"
docker stop pbw > /dev/null 2>&1
sleep 2

# Just disconnect db2_demo_data from pbw-network, and ignore errors in case it is not connected. 
echo "-> Esnure db2_demo_data is disconnected from pbw-network"
docker network disconnect -f pbw-network db2_demo_data > /dev/null 2>&1
sleep 2

echo "-> Ensure db2_demo_data is stopped"
docker stop db2_demo_data > /dev/null 2>&1
sleep 2

echo "-> Ensure docker network 'pbw-network' is removed"
docker network rm pbw-network > /dev/null 2>&1
sleep 2


#remove pbw docker image, if it exits
cmd1=$(docker images | grep default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw )
#echo "cmd1: $cmd1"


if [ -n "$cmd1" ]; then
  echo "-> pbw docker image exists, remove it now"
  echo "   -> removing pbw docker image"
  docker rmi default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw:latest
  echo "   ->  pbw docker image removed"
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
echo "1. Start PBW database in container"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   1. ---> docker start db2_demo_data" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker start db2_demo_data
sleep 2


echo ""
echo "==========================================="
echo "2. Verify database container is running"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   2. ---> docker ps | grep db2_demo_data" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker ps | grep db2_demo_data
sleep 2

echo ""
echo "==========================================="
echo "3. Create the docker network, pbw-network"
echo "---------------------------------"
echo " " | tee -a $LOG
echo "   3. ---> docker network create pbw-network" | tee -a $LOG
echo " " | tee -a $LOG
echo "---------------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker network create pbw-network
sleep 2


echo ""
echo "==========================================="
echo "4. Verify docker network is created"
echo "---------------------------------"
echo " " | tee -a $LOG
echo "   4. ---> docker network list | grep pbw-network" | tee -a $LOG
echo " " | tee -a $LOG
echo "---------------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker network list | grep pbw-network


echo ""
echo "==========================================="
echo "5. Connect database container to the Docker network"
echo "------------------------------------------------"
echo " " | tee -a $LOG
echo "   5. ---> docker network connect pbw-network db2_demo_data" | tee -a $LOG
echo " " | tee -a $LOG
echo "------------------------------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker network connect pbw-network db2_demo_data
sleep 2



echo ""
echo "==========================================="
echo "6. Build and tag the 'PlantsByWebSphere' application container image"
echo "--------------------------------------------------"
echo " " | tee -a $LOG
echo "   6. ---> docker build -f $STUDENT_PBW_BUNDLE/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw ." | tee -a $LOG
echo " " | tee -a $LOG
 echo "--------------------------------------------------"
echo ""


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker build -f $STUDENT_PBW_BUNDLE/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw .
sleep 2 


echo ""
echo "==========================================="
echo "7. Run 'PlantsByWebSphere' application in container"
echo "--------------------------------------------------"
echo " " | tee -a $LOG
echo "   7. ---> docker run -d --rm -p 9080:9080 -p 9443:9443 --network pbw-network --name pbw  default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker run -d --rm -p 9080:9080 -p 9443:9443 --network pbw-network --name pbw  default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw

echo ""
echo "---> pbw app should be running (UP) now!"
echo "--------------------------------------"
echo "docker ps | grep pbw" 
echo "--------------------------------------"
echo ""
docker ps | grep pbw
    
echo "" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "build-container script completed" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "" | tee -a $LOG

exit 0
