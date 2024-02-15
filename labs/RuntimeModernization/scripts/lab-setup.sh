######################
#  lab-setup.sh 
######################

## No input parameters required to run this script. 
#clenup studentmig bundle if present.
#unzip completed mig bundle from cloned git repo to student folder
 
STUDENT_PBW_BUNDLE="/home/techzone/Student/labs/appmod/plantsbywebsphereee6.ear_migrationBundle"

cd /home/techzone 

echo "pbw bundle path: $STUDENT_PBW_BUNDLE"

if [ -d "$STUDENT_PBW_BUNDLE" ]; then
     echo " --> Cleaning up old pbw bundle from student directory"
     rm -rf $STUDENT_PBW_BUNDLE ;
     sleep 2
fi


unzip -d /home/techzone/Student/labs/appmod/ /home/techzone/appmod-pot-labfiles/labs/RuntimeModernization/pbw-bundle-complete.zip 

rc=$?
echo "rc: $rc"
  if [[ "$rc" > "0" ]]; then
    sleep 1
    echo "--------------------------------------------------------------"
    echo "The unzip of the completed migration bundle failed" 
    echo "Script FAILED: Exiting!"
    echo "--------------------------------------------------------------"
    exit 1
    echo ""
  fi
    
echo ""
echo "=================="
echo "lab-setup script completed"
echo "=================="
echo ""


exit 0