######################
#  lab-setup.sh 
######################

## No input parameters required to run this script. 
#If the Git repo dir does not exist, clone the repo and set permissions on scripts. 
## otherwise, just set permissions on scripts, just in case. 
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


#clone the got repo for the labs, if it does not exist on the VM
if [ ! -d "$CLONE_REPO_DIR" ]; then
    echo "---> Cloning the git repo $GIT_REPO" | tee -a $LOG
    git clone $GIT_REPO
fi    
# git repo dir must exist, ensure scripts are executable
echo "---> Setting execute permissions on scripts in the lab files repo" | tee -a $LOG
find ./appmod-pot-labfiles -name "*.sh" -exec chmod +x {} \; 
echo ""
echo "-------------------------------------------"
echo "The cloned git repo is available and ready:" 
echo " --> $APPMOD_DIR"
echo "-------------------------------------------"     
echo ""

echo "---> pbw bundle path: $STUDENT_PBW_BUNDLE"

if [ -d "$STUDENT_PBW_BUNDLE" ]; then
     echo " --> Cleaning up old pbw bundle from student directory" | tee -a $LOG
     rm -rf $STUDENT_PBW_BUNDLE ;
     sleep 2
fi

echo " --> Extracting the pbw bundle from Sudent directory" | tee -a $LOG

unzip -d $APPMOD_DIR/ $CLONE_REPO_DIR/labs/RuntimeModernization/pbw-bundle-complete.zip 

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

echo "" | tee -a $LOG 
echo "--------------------------------------------------------------" | tee -a $LOG
echo "The Transformatin Advisor Migration Bundle is extracted here:" | tee -a $LOG
echo "  ---> $STUDENT_PBW_BUNDLE" | tee -a $LOG
echo "--------------------------------------------------------------"  | tee -a $LOG
    
echo "" | tee -a $LOG
echo "==========================" | tee -a $LOG
echo "lab-setup script completed" | tee -a $LOG
echo "==========================" | tee -a $LOG
echo "" | tee -a $LOG


exit 0