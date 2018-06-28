#!/bin/bash

TESTER_SAS_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load common function
#. ${TESTER_SAS_TOP_DIR}/config/xge_test_config
#. ${TESTER_SAS_TOP_DIR}/config/xge_test_lib

# Load the public configuration library
#. ${TESTER_SAS_TOP_DIR}/../config/common_config

T_SERVER_IP=''
T_CLIENT_IP=''
T_CTRL_NIC=''
###################################################################################
#Usage
###################################################################################

Usage()
{
cat <<EOF
Usage: ./xge_autotest/tester_sas.sh [options]
Options:
	-h, --help: Display this information
	-n, --ctrlNIC: the network card used to control client
	-t, --test: the tester name .if other cfg is not set,
		    tester name can help to get latest cfg you used
		    this para is forced to be set.
Example:
	bash tester_sas.sh -t luojiaxing -n "eth3"

	bash tester_sas.sh -t luojiaxing # if no other para,scripts will use the latest user cfg

EOF
}

##################################################################################
#Get all args
###################################################################################
echo -e "\033[5;35m Welcom to Use Plinth Test Suite! \033[0m"
cat << EOF
------------/\-------------
-----------/  \-------------
          /    \\
EOF

echo -e "\033[33m Luojiaxing \033[0m  \033[32m Chenjing \033[0m "

echo "  "
echo ">---------------------------------------------------------<"
echo "Thank you to ALL tester for providing high quality scripts!"
echo -e "Tester: \033[34m hehui\033[0m \033[35m  chenliangfei\033[0m "
echo ">---------------------------------------------------------< "
echo "  "

if [ ! -n "$1" ];then
	Usage
	exit 1
fi

while test $# != 0
do
	case $1 in
		--*=*) ac_option=`expr "X$1" : 'X\([^=]*\)='` ; ac_optarg=`expr "X$1" : 'X[^=]*=\(.*\)'` ; ac_shift=: ;;
		-*) ac_option=$1 ; ac_optarg=$2; ac_shift=shift ;;
		*) ac_option=$1 ; ac_shift=: ;;
	esac

	case $ac_option in
        	-h | --help) Usage ; exit 0 ;;
		-s | --sip) T_SERVER_IP=$ac_optarg ;;
		-c | --cip) T_CLIENT_IP=$ac_optarg ;;
        	-n | --ctrlNIC) T_CTRL_NIC=$ac_optarg ;;
		-t | --tester) T_TESTER=$ac_optarg ;;
		*) Usage ; echo "Unknown option $1"; exit 1 ;;
	esac

	$ac_shift
	shift
done

##################################################################################
#input the parameter
###################################################################################

if [ x"$T_TESTER" = x"" ];then
	echo "Tester name is not input!Please input it use -t..."
	exit 1
fi

. ${TESTER_SAS_TOP_DIR}/../config/common_config
. ${TESTER_SAS_TOP_DIR}/../config/common_lib
##################################################################################
#Get latest cfg pass to empty patameter
###################################################################################

if [ ! -d ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas ];then
	mkdir -p ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas
fi

if [ ! -f ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas/cfg ];then
	touch ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas/cfg
fi

if [ x"${T_CTRL_NIC}" = x"" ];then
	echo "User not input the cfg of NIC,use user pre-define value!"
	T_CTRL_NIC=`cat ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas/cfg | grep "T_CTRL_NIC" | awk -F':' '{print $NF}'`
fi

g_ctrlNIC=$T_CTRL_NIC


##################################################################################
#Update the cfg
###################################################################################
echo "SAS cfg save by ${T_TESTER}" > ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas/cfg


if [ x"${T_CTRL_NIC}" != x"" ];then
    echo "T_CTRL_NIC:${T_CTRL_NIC}" >> ${PLINTH_BASE_WORKSPACE}/user/${T_TESTER}/sas/cfg
fi

if [ x"${T_CTRL_NIC}" = x"" ];then
	echo ">--------------------------------------------------------------------------------<"
    echo -e "\033[31m Lose some cfg .Please input full parameter to recover the latest cfg! \033[0m"
    echo ">--------------------------------------------------------------------------------<"

	exit 1
else

	echo ">--------------------------------------------------------------------------------<"
    echo -e "\033[32m This time Run the test with the cfg as: NIC=${T_CTRL_NIC} \033[0m"
	echo ">--------------------------------------------------------------------------------<"
fi

COM="true"
source ${TESTER_SAS_TOP_DIR}/sas_main.sh

#COM="true"

# clean exit so lava-test can trust the results
exit 0

