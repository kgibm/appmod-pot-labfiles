######################
#  dev-deploy-pbw-ocp.sh 
######################

## No input parameters required to run this script. 
## -i  If you wnt to run the commands in the script by being prompted to continue
## exmple: dev-deploy-pbw-ocp.sh -i

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


#testing
#if [[ $INTERACTIVE_MODE == "true" ]]; then
#  echo "prompt required"
#  echo ""
#  read -n 1 -r -s -p $'Press enter to continue...\n'
#  echo ""
#  echo "continuing"  
#fi


STUDENT_LAB_DIR="/home/techzone/Student/labs/appmod"
WORKING_DIR="/home/techzone/Student/labs/appmod/pbw-bundle-complete/deploy/kustomize"
#PWD=pwd
LOGS=$STUDENT_LAB_DIR/logs
LOG=$STUDENT_LAB_DIR/logs/dev-deploy-pbw-ocp.log

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


cd $WORKING_DIR

echo ""
echo ""
echo "-> working directory: $PWD" | tee $LOG
echo ""

# Cleanup any existing components

#remove deployment
#remove image stream
#go to default project 
#delete dev project 
#logout of docker
#logout of ocp
#remove dev tag from docker image

echo ""
echo "----------------------"
echo "Running cleanup steps" 
echo "----------------------"

sleep 2


echo "---------------------------------------"
echo "login to OCP"
echo "   ---> oc login -u ocadmin -p ibmrhocp"
echo "---------------------------------------"
echo ""
oc login -u ocadmin -p ibmrhocp

sleep 2


echo "---------------------------------------"
echo "Switch to the 'dev' project"
echo "   ---> oc project dev"
echo "---------------------------------------"
echo ""
oc project dev > /dev/null 2>&1

sleep 2

#remove the pbw deployment
echo "-> Esnure pbw deployment is removed"
oc delete -k overlays/dev > /dev/null 2>&1
sleep 5

# remove the pbw image stream 
echo "-> Esnure pbw image stream is removed from project"
oc delete is pbw > /dev/null 2>&1
sleep 3

echo "-> switch to the default project so the dev project can be removed"
oc project default > /dev/null 2>&1
sleep 2


echo "-> remove the dev project"
oc delete project dev > /dev/null 2>&1
sleep 3


echo "-> logout of docker, image registry"
docker logout > /dev/null 2>&1
sleep 2

echo "-> logout of ocp cli"
oc logout > /dev/null 2>&1
sleep 2


echo "-> remove 'dev' tag from docker image"
docker rmi default-route-openshift-image-registry.apps.ocp.ibm.edu/dev/pbw > /dev/null 2>&1
sleep 2

echo "----------------------"
echo "End of cleanup steps"
echo "----------------------"

sleep 2


#Deploy the PBW app to OCP


echo ""
echo "============================================" | tee -a $LOG
echo "Push pbw image to registry and deploy to OCP" | tee -a $LOG
echo "============================================" | tee -a $LOG
echo ""


echo ""
echo "==========================================="
echo "1. Tag 'PlantsByWebSphere' image for 'dev'"
echo "--------------------------------------------------"
echo " " | tee -a $LOG
echo "   1. ---> docker tag apps/pbw default-route-openshift-image-registry.apps.ocp.ibm.edu/dev/pbw " | tee -a $LOG
echo " " | tee -a $LOG
 echo "--------------------------------------------------"
echo ""

sleep 2 

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
docker tag apps/pbw default-route-openshift-image-registry.apps.ocp.ibm.edu/dev/pbw
sleep 3 




echo ""
echo "==========================================="
echo "2. login to OCP"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   2. ---> oc login -u ocadmin -p ibmrhocp" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
oc login -u ocadmin -p ibmrhocp
oc project default

sleep 3
echo ""
echo ""
echo "==========================================="
echo "3. create new project 'dev'"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   3. ---> oc new-project dev" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""

if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
oc new-project dev
sleep 3

echo ""
echo ""
echo "==========================================="
echo "4. switch to 'dev' project"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   4. ---> oc project dev" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
oc project dev
sleep 3

echo ""
echo ""
echo "==========================================="
echo "5. login to the OCP internal registry"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   5. ---> docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp.ibm.edu" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp.ibm.edu
sleep 3

echo ""
echo ""
echo "==========================================="
echo "6. push the PBW image to OCP internal registry"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   6. ---> docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/dev/pbw:latest" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/dev/pbw:latest
sleep 3

echo ""
echo ""
echo "==========================================="
echo "-> 7. list the new pbw image stream"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   7. ---> oc get is | grep pbw" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
oc get is | grep pbw
sleep 3

echo ""
echo ""
echo "==========================================="
echo "8. deploy pbw app to OCP"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   8. ---> oc apply -k overlays/dev" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
oc apply -k overlays/dev
echo ""
echo "WAITING 30 seconds for deployment!"
sleep 5
echo "   > 25 seconds remaining"
sleep 5
echo "   > 20 seconds remaining"
sleep 5
echo "   > 15 seconds remaining"
sleep 5
echo "   > 10 seconds remaining"
sleep 5
echo "   > 5 seconds remaining"
sleep 5
echo ""
echo "   > script continuing..."
sleep 2
echo ""
echo ""
echo "==========================================="
echo "9. list the new deployment"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   9. ---> oc get deployment" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
oc get deployment
echo ""
echo "WAITING 15 seconds for pods to finalize!"
sleep 5
echo "   > 10 seconds remaining"
sleep 5 
echo "   > 5 seconds remaining"
sleep 5
echo "   > script continuing..."
sleep 2
echo "" 
echo ""
echo "==========================================="
echo "10. get the status of the PBW pod"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   10. ---> oc get pods" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
oc get pods
sleep 3 
echo ""
echo ""
echo "==========================================="
echo "11. get the route to PBW app"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   11. ---> oc get route | grep plantsbywebsphereee6" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
sleep 2
if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi   
pbw_route=$(oc get route | grep plantsbywebsphereee6 | awk '{print $2}')
echo ""
echo "------------------------------------------------" | tee -a $LOG
echo "PlantsByWebSphere Route: http://$pbw_route/PlantsByWebSphere" | tee -a $LOG
echo "------------------------------------------------" | tee -a $LOG

echo "" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "deploy-pbw-ocp script completed" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "" | tee -a $LOG


exit 0
