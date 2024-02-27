######################
#  lab-setup.sh 
######################

## No input parameters required to run this script. 
#cleanup student migration bundle if present.
#unzip completed mig bundle from cloned git repo to student folder
 
LABS_DIR=/home/techzone/Student/labs
APPMOD_DIR=$LABS_DIR/appmod 
 
GIT_REPO="https://github.com/IBMTechSales/appmod-pot-labfiles.git"
CLONE_REPO_DIR=/home/techzone/appmod-pot-labfiles

 
STUDENT_PBW_BUNDLE="$APPMOD_DIR/pbw-bundle-complete"

LOGS=$APPMOD_DIR/logs
LOG=$APPMOD_DIR/logs/lab-setup.log

cd /home/techzone 


echo ""
echo "-> working directory: $PWD" | tee $LOG
echo ""




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


echo "---> pbw bundle path: $STUDENT_PBW_BUNDLE"

if [ -d "$STUDENT_PBW_BUNDLE" ]; then
     echo " --> Cleaning up old pbw bundle from student directory" | tee -a $LOG
     rm -rf $STUDENT_PBW_BUNDLE ;
     sleep 2
fi
echo ""
echo "----------------------------------------------------"
echo " --> Extracting the pbw bundle from Sudent directory" | tee -a $LOG
echo ""
echo "unzip -d $APPMOD_DIR/ $CLONE_REPO_DIR/labs/RuntimeModernization/pbw-bundle-complete-dev.zip" 
echo "-----------------------------------------------------"
sleep 4

unzip -d $APPMOD_DIR/ $CLONE_REPO_DIR/labs/RuntimeModernization/pbw-bundle-complete-dev.zip 

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
  
  sleep 3

echo "" | tee -a $LOG 
echo "--------------------------------------------------------------" | tee -a $LOG
echo "The Transformatin Advisor Migration Bundle is extracted here:" | tee -a $LOG
echo "  ---> $STUDENT_PBW_BUNDLE" | tee -a $LOG
echo "--------------------------------------------------------------"  | tee -a $LOG

sleep 2 
    
echo "" | tee -a $LOG
echo "==========================" | tee -a $LOG
echo "lab-setup script completed" | tee -a $LOG
echo "==========================" | tee -a $LOG
echo "" | tee -a $LOG


exit 0