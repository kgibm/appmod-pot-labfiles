######################
#  reset-lab.sh 
######################

## No input parameters required to run this script. 
## You will be prompted to continue, as this script cleans up lab resources


#Have user reply "y" to continue the script to contiue 
echo ""
echo "This script will cleanup resurces in the lab environemnt:"
echo ""
read -p "---> Are you sure you want to continue? (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo continuing... 
    ;;
    * )
        exit 1
    ;;
esac

echo ""
echo "----------------------------------"
echo "Running cleanup steps from staging" 
echo "----------------------------------"
echo ""

# Cleanup any existing components

#remove deployment
#remove image stream
#go to default project 
#delete staging project 
#logout of docker
#logout of ocp
#remove staging tag from docker image

WORKING_DIR="/home/techzone/Student/labs/appmod/pbw-bundle-complete/deploy/kustomize"

cd $WORKING_DIR

echo ""
echo "-> working directory: $PWD" 
echo ""

echo "---------------------------------------"
echo "login to OCP"
echo "---------------------------------------"
echo "   ---> oc login -u ocadmin -p ibmrhocp"
echo "---------------------------------------"
echo ""
oc login -u ocadmin -p ibmrhocp

sleep 2


echo "---------------------------------------"
echo "Switch to the 'staging' project"
echo "   ---> oc project staging"
echo "---------------------------------------"
echo ""
oc project staging > /dev/null 2>&1

#remove the pbw deployment
echo "-> Esnure pbw deployment is removed"
oc delete -k overlays/staging > /dev/null 2>&1
sleep 5

# remove the pbw image stream 
echo "-> Esnure pbw image stream is removed from project"
oc delete is pbw > /dev/null 2>&1
sleep 3

echo "-> switch to the default project so the staging project can be removed"
oc project default > /dev/null 2>&1
sleep 2


echo "-> remove the staging project"
oc delete project staging > /dev/null 2>&1
sleep 3


echo "-> logout of docker, image registry"
docker logout > /dev/null 2>&1
sleep 2

echo "-> logout of ocp cli"
oc logout > /dev/null 2>&1
sleep 2


echo "-> remove 'staging' tag from docker image"
docker rmi default-route-openshift-image-registry.apps.ocp.ibm.edu/staging/pbw > /dev/null 2>&1
sleep 2

echo "--------------------------------"
echo "End of cleanup steps for Staging"
echo "--------------------------------"
echo ""
sleep 2


echo ""
echo "-----------------------------"
echo "Running cleanup steps for dev" 
echo "-----------------------------"
echo ""

sleep 2

# Cleanup any existing components

#remove deployment
#remove image stream
#go to default project 
#delete dev project 
#logout of docker
#logout of ocp
#remove dev tag from docker image

WORKING_DIR="/home/techzone/Student/labs/appmod/pbw-bundle-complete/deploy/kustomize"

cd $WORKING_DIR

echo ""
echo "-> working directory: $PWD" 
echo ""

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

echo "----------------------------"
echo "End of cleanup steps for dev"
echo "----------------------------"

sleep 2

echo ""
echo "--------------------------------"
echo "Running cleanup steps for builds" 
echo "--------------------------------"
echo ""

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

cmd1=$(docker images | grep apps/pbw )
#echo "cmd1: $cmd1"

if [ -n "$cmd1" ]; then
  echo "-> pbw docker image exists, remove it now"
  echo "   -> removing pbw docker image"
  docker rmi apps/pbw:latest > /dev/null 2>&1
  echo "   ->  apps/pbw docker image removed"
  sleep 2
fi

echo "-------------------------------"
echo "End of cleanup steps for builds"
echo "-------------------------------"

sleep 2


echo ""
echo "------------------------------------------"
echo "Running cleanup steps for migration bundle" 
echo "------------------------------------------"
echo ""

sleep 2

LABS_DIR=/home/techzone/Student/labs
APPMOD_DIR=$LABS_DIR/appmod 
STUDENT_PBW_BUNDLE="$APPMOD_DIR/pbw-bundle-complete"

echo "-> pbw bundle path: $STUDENT_PBW_BUNDLE"

if [ -d "$STUDENT_PBW_BUNDLE" ]; then
     echo " -> Cleaning up old pbw bundle from student directory" 
     rm -rf $STUDENT_PBW_BUNDLE ;
     sleep 2
fi
echo "-----------------------------------------"
echo "End of cleanup steps for migration bundle"
echo "-----------------------------------------"

    
echo "" 
echo "================================" 
echo "lab-reset.sh script completed" 
echo "================================" 
echo "" 



