#!/bin/bash

# Disk negotiated link rate query
# IN : N/A
# OUT: N/A
function disk_negotiated_link_rate_query()
{
    Test_Case_Title="disk_negotiated_link_rate_query"

    echo "Begin to run disk_negotiated_link_rate_query function"

    local dir_info
    dir_info=`ls ${PHY_FILE_PATH}`
    disk_type=$(echo ${TEST_CASE_TITLE} | awk -F "_" '{print $3}')
    for dir in ${dir_info}
    do
        type=`cat ${PHY_FILE_PATH}/${dir}/target_port_protocols`
        [ x"${type}" != x"${disk_type}" ] && continue
        rate_value=`cat ${PHY_FILE_PATH}/${dir}/negotiated_linkrate | awk -F '.' '{print $1}'`
        BRate=1
        if [ $disk_type == "ssp" ];then
        rate_info=`echo ${SAS_DISK_NEGOTIATED_LINKRATE_VALUE} | sed 's/|/ /g'`
        fi
        if [ $disk_type == "sata" ];then
        rate_info=`echo ${SATA_DISK_NEGOTIATED_LINKRATE_VALUE} | sed 's/|/ /g'`
        fi
        max_rate=`cat ${PHY_FILE_PATH}/${dir}/maximum_linkrate`
        min_rate=`cat ${PHY_FILE_PATH}/${dir}/minimum_linkrate`
        for rate in ${rate_info}
        do
            if [ $(echo "${rate_value} ${rate}"|awk '{if($1=$2){print 0}else{print 1}}') -eq 0 ]
            then
                if [ ${rate_value} -le ${max_rate} ] && [ ${rate_value} -ge ${min_rate} ];then
                    BRate=0
                    break
                fi
            fi
        done

        if [ $BRate -eq 1 ]
        then
            MESSAGE="FAIL\t\"${dir}\" negotiated link rate query ERROR."
  	        echo ${MESSAGE}
            return 1
        fi
    done
    MESSAGE="PASS"
    echo ${MESSAGE}
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main
