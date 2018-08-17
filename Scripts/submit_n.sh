#! /bin/sh
# program created by Benjamin Misselwitz
 
# sleep 1500
OutputDir="/cluster/home/misselwb/CMOST8_3D/"
AccountingFileSubmitted="/BrutusAccounting.txt"
AccountingFileFinished="/BrutusFinished.txt"
FinishedDir="/cluster/home/misselwb/CMOST8_3D_Finished/"

JobOutput="/cluster/home/misselwb/CMOST8_3D_Out/"

for foldername1 in $(ls ${OutputDir}); do

###############################
# mv finished jobs 
###############################


#        if [ -d ${FinishedDir}/${foldername1} ]; then  
#           echo "exists" ${FinishedDir} ${foldername1}
#        else
#           echo "creating" ${FinishedDir} ${foldername1}
#           mkdir ${FinishedDir}/${foldername1}
#	fi
#
#	if test -d ${OutputDir}/${foldername1}; then	
#              for filename in *Results.mat; do
#              f1=`echo $filename |awk -F"_Results" '{print $1$2}'`
#              echo "moving" $f1 $filename
#              mv $f1 $filename $FinishedDir
#              done
#	fi
#
###############################
# submit new jobs 
###############################

#num is the parameter which defines how many jobs are simultaneously submitted

        if test -d ${OutputDir}/${foldername1}; then   
	      num=20;
	      c1=`ls -ltr ${OutputDir}/${foldername1}/*mat|wc -l`;
	      c=$(($c1/$num+1));


              for((i=1;i<c;i++));do
              m=$(( $i * $num ));
              #echo $n $m
              
              InputList=`ls -tlr ${OutputDir}/${foldername1}/*mat | head -n $m | tail -n $num | awk '{ printf $9}'`;
              echo $InputList
              echo " "
              echo " "
	      OutGrp=`ls -tlr ${OutputDir}/${foldername1}/*mat | head -n $m | tail -n 1 | awk '{ printf $9}'| cut -d'.' -f1| rev | cut -d'/' -f1|rev`;
              JobOutputName=$JobOutput/${OutGrp}.txt
              echo "Outputis " $JobOutputName
              bsub -W 08:00 -r -o $JobOutputName $HOME/CMOSTClusterSub_n $InputList ${FileFinished} ${MessageFinished}
              done
        fi


done

exit 0

