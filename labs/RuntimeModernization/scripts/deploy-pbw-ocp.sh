######################
#  deploy-pbw-ocp.sh 
######################

## No input parameters required to run this script. 

STUDENT_LAB_DIR="/home/techzone/Student/labs/appmod"
WORKING_DIR="/home/techzone/Student/labs/appmod/pbw-bundle-complete/deploy/kustomize"
#PWD=pwd
LOGS=$STUDENT_LAB_DIR/logs
LOG=$STUDENT_LAB_DIR/logs/deploy-pbw-ocp.log

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
#delete apps project 
#logout of docker
#logout of ocp


# if db2 is running, check if its connected to pbw network
# if it is, disconnect from the network, then stop the db
#
echo ""
echo "----------------------"
echo "Running cleanup steps" 
echo "----------------------"


sleep 2

#remove the pbw deployment
echo "-> Esnure pbw deployment is removed"
oc apply -k overlays/dev > /dev/null 2>&1
sleep 5

# remove the pbw image stream 
echo "-> Esnure pbw image stream is removed from project"
oc delete is pbw > /dev/null 2>&1
sleep 3

echo "-> switch to the defualt project so that I can delete the apps project"
oc project default > /dev/null 2>&1
sleep 2


echo "-> remove the apps project"
oc delete project apps > /dev/null 2>&1
sleep 3


echo "-> logout of docker, image registry"
docker logout > /dev/null 2>&1
sleep 2

echo "-> logout of ocp cli"
oc logout > /dev/null 2>&1
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


echo "-> login to OCP"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   1. -> oc login -u ocadmin -p ibmrhocp" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
oc login -u ocadmin -p ibmrhocp
sleep 3

echo "-> create new project 'apps'"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   2. -> oc new-project apps" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
oc new-project apps
sleep 3

echo "-> switch to 'apps' project"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   3. -> oc project apps" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
oc project apps
sleep 3

echo "-> login to the OCP internal registry"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   4. -> docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp.ibm.edu" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp.ibm.edu
sleep 3

echo "-> push the PBW image to OCP internal registry"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   5. -> docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw:latest" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw:latest
sleep 3


echo "-> list the new pbw image stream"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   6. -> oc get is | grep pbw" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
oc get is | grep pbw
sleep 3

echo "-> deploy pbw app to OCP"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   7. -> oc apply -k overlays/dev" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
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
echo "-> list the new deployment"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   8. -> oc get deployment" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
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

echo "-> get the status of the PBW pod"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   10. -> oc get pods" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
oc get pods
sleep 3 

echo "-> get the route to PBW app"
echo "--------------------------"
echo " " | tee -a $LOG
echo "   11. -> oc get route | grep plantsbywebsphereee6" | tee -a $LOG
echo " " | tee -a $LOG
echo "--------------------------"
echo ""
sleep 2

pbw_route=$(oc get route | grep plantsbywebsphereee6 | awk '{print $2}')

echo "------------------------------------------------" | tee -a $LOG
echo "PlantsByWebSphere Route: http://$pbw_route/PlantsByWebSphere" | tee -a $LOG
echo "------------------------------------------------" | tee -a $LOG

echo "" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "deploy-pbw-ocp script completed" | tee -a $LOG
echo "================================" | tee -a $LOG
echo "" | tee -a $LOG


exit 0

