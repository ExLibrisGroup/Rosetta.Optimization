#!/bin/csh -f

source /exlibris/dps/d4_1/profile/.cshrc
if ($status != 0) goto error

date > summary.txt
echo "Time,Queue Name,State,Waiting In Queue" >> summary.txt
foreach x (`seq 1 1 $1`)
    sqlplus -s >> summary.txt << EOF
     ${ORA_USER_PREFIX}SHR00/`get_ora_passwd ${ORA_USER_PREFIX}SHR00`
     SET NEWPAGE NONE
     SET PAGESIZE 0
     SET SPACE 0
     SET LINESIZE 16000
     SET ECHO OFF
     SET FEEDBACK OFF
     SET VERIFY OFF
     SET HEADING OFF
     SET TERMOUT OFF
     SET TRIMOUT ON
     SET TRIMSPOOL ON
     SET COLSEP |
     select to_char(sysdate,'HH24:MI:SS') || ',' || q_name || ':' || state || ',' || count(*) from jobs_queue_table group by q_name, state;
EOF
    sleep $2
end

if ($status != 0) goto error


done:
     exit 0
error:
     exit 1