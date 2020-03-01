#!/usr/bin/bash
dbExist="no";
function checkDbExistance {
	if [ -d "./databases/$1" ] 
	then
		dbExist="yes"
	else
		dbExist="no"
	fi
}

function dropDb {
	dbExist="no";
	echo "you chossed deleteDB option";
	showDataBases
	echo "please enter name of DB you want to delete";
	read dbName
	checkDbExistance $dbName
	if [ -z $dbName ]
		then
			echo "Name is Not Valid"
		else
			if [ $dbExist == "no" ] 
				then
					echo "Failed To delete DB : DB $dbName is not existed."
				else
					rm databases/${dbName} -r
				echo "DB $dbName deleted successfully";
			fi	
	fi
	
}

function createDb {
	dbExist="no";
	echo "you chossed createDB option";
	echo "please enter name of DB";
	read dbName;
	checkDbExistance $dbName;

	if [ -z $dbName ]
		then
			echo "Name is Not Valid"
		else
			if [ $dbExist == "no" ] 
				then
					echo "DB $dbName Created successfully";
					mkdir databases/${dbName}	
				else
					echo "Failed To create DB : DB $dbName is already existed."
			fi	
	fi
	

}

function showDataBases {
	echo "The DataBases List Is:"
	ls ./databases | column -s -t;
}

function connectDataBase {
	dbExist="no";
	showDataBases
	echo "please enter the DB Name you want to Connect"
	read dbName
	checkDbExistance $dbName;
	if [ -z $dbName ]
		then
			echo "Name is Not Valid"
		else
			if [ $dbExist == "no" ] 
				then
					echo "DB $dbName Doesn't existed."
				else
					clear
					./connectDB $dbName;	
			fi
	fi	
}
#========================================================
typeset -i selectFlag;
selectFlag=1
while test $selectFlag -eq 1
	do
	echo "===================================="
	echo "===================================="
	select choice in "Create Database" "List Databases" "Connect To Databases" "Drop Database" "clear screen" "exit"
		do
			case $choice in
				"Create Database") createDb; break; ;;
				"List Databases") showDataBases; break; ;;
				"Connect To Databases") connectDataBase; break; ;;
				"Drop Database") dropDb; break; ;;
				"clear screen") clear; break; ;;
				"exit") selectFlag=0; break; ;;
				*) echo "please enter a valid option "; break; ;;
			esac
		done
	done
