######################
#  kustomize-staging.sh 
######################

## No input parameters required to run this script. 


#verify the kustomize dev overlay folder exists. If not, exit,since the bundle is not there
#vrify the source kustomize-overlays for staging exists. If not, exit. 
#copy the source kustomize staging overlays to Student kustomize folder in the bundle dir
#verify the copied folder and files exist, if not, fail and exit

STUDENT_LAB_DIR="/home/techzone/Student/labs/appmod"
STUDENT_PBW_BUNDLE_DIR="/home/techzone/Student/labs/appmod/pbw-bundle-complete"
#PWD=pwd
LOGS=$STUDENT_LAB_DIR/logs
LOG=$STUDENT_LAB_DIR/logs/kustomize-staging.log

GIT_REPO_WORKING_DIR=/home/techzone/appmod-pot-labfiles/labs/RuntimeModernization
STUDENT_KUSTOMIZE_OVERLAYS_DIR=$STUDENT_PBW_BUNDLE_DIR/deploy/kustomize/overlays
SOURCE_KUSTOMIZE_OVERLAYS_DIR=$GIT_REPO_WORKING_DIR/kustomize-overlays/staging

#echo "student overlay dir: $STUDENT_KUSTOMIZE_OVERLAYS_DIR"
#echo "source overlay dir: $SOURCE_KUSTOMIZE_OVERLAYS_DIR"

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



cd /home/techzone

echo ""
echo "-> working directory: $PWD" | tee $LOG
echo ""


#Ensure the source dir for kustomize staging overlay dir exists
if [  ! -d "$SOURCE_KUSTOMIZE_OVERLAYS_DIR" ]; then
     echo "ERROR: Exiting!" | tee -a $LOG
     echo "The source directory for the Kustomize staging overlays does not exist." | tee -a $LOG
     echo "$SOURCE_KUSTOMIZE_OVERLAYS_DIR" | tee -a $LOG
     exit 1
 else  
  echo "" | tee -a $LOG
  echo "OK, Source directory verified" | tee -a $LOG
  echo  "   --> $SOURCE_KUSTOMIZE_OVERLAYS_DIR"  | tee -a $LOG
  echo "" | tee -a $LOG
fi



#Ensure the student dir for kustomize overlay dir exists
if [ ! -d "$STUDENT_KUSTOMIZE_OVERLAYS_DIR" ]; then
     echo "ERROR: Exiting!" | tee -a $LOG
     echo "The kustomize overlay directory in the target does not exist." | tee -a $LOG
     echo "$STUDENT_KUSTOMIZE_OVERLAYS_DIR" | tee -a $LOG
     exit 1
  else  
  echo "" | tee -a $LOG
  echo "OK, Target directory verified" | tee -a $LOG
  echo  "   --> $STUDENT_KUSTOMIZE_OVERLAYS_DIR"  | tee -a $LOG
  echo "" | tee -a $LOG
fi  
  
#If the kustomize staging directory exists, delete it before copying to it.  
if [  -d "$STUDENT_KUSTOMIZE_OVERLAYS_DIR/staging" ]; then
     echo "Cleaning up the target staging overlay directory!" | tee -a $LOG
     echo "   --> $STUDENT_KUSTOMIZE_OVERLAYS_DIR/staging" | tee -a $LOG
     echo "" | tee -a $LOG
     rm -rf $STUDENT_KUSTOMIZE_OVERLAYS_DIR/staging
fi    
  

#Copy the source folder to the target location. 

echo "" | tee -a $LOG
echo "Configuring the staging Overlay directory" | tee -a $LOG
echo "   --> cp -r $SOURCE_KUSTOMIZE_OVERLAYS_DIR $STUDENT_KUSTOMIZE_OVERLAYS_DIR" | tee -a $LOG
echo "" | tee -a $LOG

cp -r $SOURCE_KUSTOMIZE_OVERLAYS_DIR $STUDENT_KUSTOMIZE_OVERLAYS_DIR


#Ensure the student staging overlay directory is now created
if [ ! -d "$STUDENT_KUSTOMIZE_OVERLAYS_DIR/staging" ]; then
     echo "" | tee -a $LOG
     echo "ERROR: Exiting!" | tee -a $LOG
     echo "The kustomize 'staging' overlay directory was not properly configured." | tee -a $LOG
     echo "$STUDENT_KUSTOMIZE_OVERLAYS_DIR/staging" | tee -a $LOG
     echo "" | tee -a $LOG
     exit 1
  else  
  echo "" | tee -a $LOG
  echo "OK, Kustomize 'staging' overlay was sucessfully configured" | tee -a $LOG
  echo  "   --> $STUDENT_KUSTOMIZE_OVERLAYS_DIR/staging"  | tee -a $LOG
  echo "" | tee -a $LOG
fi  


  
echo "" | tee -a $LOG
echo "=====================================" | tee -a $LOG
echo "kustomize-staging.sh script completed" | tee -a $LOG
echo "=====================================" | tee -a $LOG
echo "" | tee -a $LOG

exit 0