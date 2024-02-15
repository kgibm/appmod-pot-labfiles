######################
#  build-container.sh 
######################

## No input parameters required to run this script. 
#clenup studentmig bundle if present.
#unzip completed mig bundle from cloned git repo to student folder
 
STUDENT_PBW_BUNDLE="/home/techzone/Student/labs/appmod/plantsbywebsphereee6.ear_migrationBundle"
PWD=pwd

cd $STUDENT_PBW_BUNDLE

echo ""
echo "-> working directory: $PWD"

# Cleanup any existing components


# if db2 is running, check if its connected to pbw network
# if it is, disconnect from the network, then stop the db
#
echo ""
echo "----------------------"
echo "Running cleanup steps" 
echo "----------------------"

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
echo ""
echo "----------------------"
echo "End of cleanup steps"
echo "----------------------"

sleep 2

#build the container
echo ""
echo "-> start PBW database in container"
echo "--------------------------"
echo "docker start db2_demo_data"
echo "--------------------------"
echo ""

docker start db2_demo_data
sleep 2


echo ""
echo "-> Verify database container is running"
echo "--------------------------"
echo "docker ps | grep db2_demo_data"
echo "--------------------------"
echo ""
docker ps | grep db2_demo_data
sleep 2

echo ""
echo "-> Create the docker network, pbw-network"
echo "---------------------------------"
echo "docker network create pbw-network"
echo "---------------------------------"
echo ""
docker network create pbw-network
sleep 2


echo ""
echo "-> Verify docker network is created"
echo "---------------------------------"
echo "docker network list | grep pbw-network"
echo "---------------------------------"
echo ""
docker network list | grep pbw-network


echo ""
echo "-> Connect database container to the Docker network"
echo "------------------------------------------------"
echo "docker network connect pbw-network db2_demo_data"
echo "------------------------------------------------"
echo ""
docker network connect pbw-network db2_demo_data
sleep 2



echo ""
echo "-> Build and tag the 'PlantsByWebSphere' application container image"
echo "--------------------------------------------------"
echo "docker build -f /home/techzone/Student/labs/appmod/plantsbywebsphereee6.ear_migrationBundle/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw ."
echo "--------------------------------------------------"
echo ""
docker build -f /home/techzone/Student/labs/appmod/plantsbywebsphereee6.ear_migrationBundle/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw .
sleep 1


#docker run --rm -p 9080:9080 -p 9443:9443 --network pbw-network  default-route-openshift-image-registry.apps.ocp.ibm.edu/apps/pbw

    
echo ""
echo "================================"
echo "build-container script completed"
echo "================================"
echo ""

exit 0

