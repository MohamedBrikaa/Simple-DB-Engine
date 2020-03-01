#!/usr/bin/bash
echo "===================================="
dbName=$1;
echo "connected to DB $1"
tableExist="no";

function checkTableExistance {
	if [ -f "./databases/$dbName/$1" ] 
	then
		tableExist="yes"
	else
		tableExist="no"
	fi	
}

function listTables {
	echo "The Tables are:"
	ls ./databases/$dbName | column -s -t;
}

function createTable {
	tableExist="no";
	echo "you chossed create Table option";
	echo "please enter name of Table";
	read tableName;
	checkTableExistance $tableName;

	if [ -z $tableName ]
		then
			echo "Name is Not Valid"
		else
			if [ $tableExist == "no" ] 
			then
				createColumns
			else
				echo "Failed To create Table : Table $tableName is already existed."
			fi
	fi
}

function createColumns {
	echo "enter the number of columns"
    read numOfColumns
    typeset -i i;
    i=0
	if [ -z $numOfColumns ]
		then
			echo "number is Not Valid"
		else
			while [ $i -lt $numOfColumns ] 
				do
					i=$i+1
					echo "enter column $i"
					read colName
					if [ -z $colName ]
						then
							echo "please enter a vlid cloumn name"
							i=$i-1
						else
							columns="$columns,$colName"
					fi
				done
			columns=${columns#","}
			echo "cloumns are :" $columns
			touch databases/${dbName}/${tableName}
			echo $columns>databases/${dbName}/${tableName}
			echo "Table $tableName Created successfully";
	fi
}

function dropTable {
	tableExist="no";
	echo "you chossed drop Table option";
    listTables
	echo "please enter name of Table";
	read tableName;
	checkTableExistance $tableName;

	if [ -z $tableName ]
		then
			echo "Name is Not Valid"
		else
		if [ $tableExist == "yes" ] 
			then
				rm databases/${dbName}/${tableName}
				echo "Table $tableName deleted successfully";
			else
				echo "Failed To delete Table : Table $tableName is not exist."
			fi
	fi
}

function insertInto {
	tableExist="no";
		echo "you chossed insert Table option";
    listTables
	echo "please enter name of Table";
	read tableName;
	checkTableExistance $tableName;

	if [ -z $tableName ]
		then
			echo "Name is Not Valid"
		else
			if [ $tableExist == "yes" ] 
				then
					insetTableData $tableName
				else
					echo "Failed To insert into Table : Table $tableName is not exist."
				fi
	fi
}

function insetTableData {
	tableName=$1
	columnsNum=`awk -F, '{ if (NR==1) {print NF} }' "databases/$dbName/$tableName" `
	columnNames=`awk -F, '{ if (NR==1) {print $0;} }' "databases/$dbName/$tableName" `
	IFS=','
	read -a colNameArr <<< "$columnNames"
	echo "the columns of this table is : "${colNameArr[@]}
	IFS=''
	row=''
	# #=======================
	typeset -i i;
    i=0
    while [ $i -lt $columnsNum ] 
    do
        echo "enter ${colNameArr[$i]}"
        read
        row="$row,$REPLY"
		i=$i+1
	done
	row=${row#","}
    echo "the new row is :" $row
	echo $row>>databases/$dbName/${tableName}
	echo "Data inserted successfully";
}

function selectFrom {
	tableExist="no";
	echo "you chossed select from Table option";
    listTables
	echo "please enter name of Table";
	read tableName;
	checkTableExistance $tableName;

	if [ -z $tableName ]
		then
			echo "Name is Not Valid"
		else
			if [ $tableExist == "yes" ] 
				then
					echo "please enter The (id) you want to search for or (all) for all";
					read id;
					if [ -z $id ]
						then
							echo "id is Not Valid"
						else
							if [ $id == "all" ]
								then
								disolayTableData $tableName
							else
								awk -F, '{if($1=='$id' || NR==1) print $0}' databases/$dbName/$tableName | column -t -s ","
							fi
					fi
				else
					echo "Failed To select from Table : Table $tableName is not exist."
			fi
	fi

}

function disolayTableData {
	tableName=$1
	echo ""
	echo "******** the data of table $tableName is *********"
	column -t -s "," databases/$dbName/$tableName
	# awk -F, '{ print $0; }' "databases/$dbName/$tableName"
	echo "************************************************"
	echo ""
}

function deleteFrom {
	tableExist="no";
	echo "you chossed delete from Table option";
    listTables
	echo "please enter name of Table";
	read tableName;
	checkTableExistance $tableName;
	if [ -z $tableName ]
		then
			echo "Name is Not Valid"
		else
			if [ $tableExist == "yes" ] 
				then
					removeRecord $tableName
				else
					echo "Failed To delete from Table : Table $tableName is not exist."
			fi
	fi
}

function removeRecord {
	tableName=$1
	disolayTableData $tableName
	echo "please enter the id of the record you want to delete"
	read id
	awk -F, '{if($1!='$id') print $0}' databases/$dbName/$tableName > databases/$dbName/tmp
	cat databases/$dbName/tmp>databases/$dbName/$tableName
	rm databases/$dbName/tmp
	echo "the new Table is"
	disolayTableData $tableName
}
#====================================
typeset -i connectionSelectFlag;
connectionSelectFlag=1
while test $connectionSelectFlag -eq 1
	do
	echo "===================================="
	echo "================= $dbName =============="
	echo "===================================="
	select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "clear screen" "exit"
		do
			case $choice in
				"Create Table") createTable; break; ;;
				"List Tables") listTables; break; ;;
				"Drop Table") dropTable; break; ;;
				"Insert into Table") insertInto; break; ;;
				"Select From Table") selectFrom; break; ;;
				"Delete From Table") deleteFrom; break; ;;
				"clear screen") clear; break; ;;
				"exit") connectionSelectFlag=0; break; ;;		
				*) echo "enter a valid option"; break; ;;
			esac
		done
	done