#!/bin/bash

export DATABASE_KMS_NAME="${database_kms_name}"
export DATABASE_KMS_HOST="${database_kms_host}"
export DATABASE_KMS_USERNAME="${database_kms_username}"
export DATABASE_KMS_PASSWORD="${database_kms_password}"

export DATABASE_EKM_NAME="${database_ekm_name}"
export DATABASE_EKM_HOST="${database_ekm_host}"
export DATABASE_EKM_USERNAME="${database_ekm_username}"
export DATABASE_EKM_PASSWORD="${database_ekm_password}"

function install_tools(){
  echo "Installing tools."
  # Install pgbench
  dnf install -y \
       https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  dnf -qy module disable postgresql
  dnf install -y postgresql15-contrib
}



function run_kms_tests(){
  echo "Running KMS tests."
  # Init performance tests
  /usr/pgsql-15/bin/pgbench -i -s 20 --host="${database_kms_host}" --username="${database_kms_username}" ${database_kms_name}
  # Run performance tests
  /usr/pgsql-15/bin/pgbench --log --protocol=extended --report-per-command --jobs=2 --client=10 --transactions=50 --host="${database_kms_host}" --username="${database_kms_username}" ${database_kms_name}
}

function run_ekm_tests(){
  echo "Running EKM tests."
  # Init performance tests
  /usr/pgsql-15/bin/pgbench -i -s 20 --host="${database_ekm_host}" --username="${database_ekm_username}" ${database_ekm_name}
  # Run performance tests
  /usr/pgsql-15/bin/pgbench --log --protocol=extended --report-per-command --jobs=2 --client=10 --transactions=50 --host="${database_ekm_host}" --username="${database_ekm_username}" ${database_ekm_name}
}

########################################################################################################################
#
#                                         Main
#
########################################################################################################################
cat<<'EOF'
           _..._
         .'     '.
        /  _   _  \
        | (o)_(o) |
         \(     ) /
         //'._.'\ \
        //   .   \ \
       ||   .     \ \
       |\   :     / |
       \ `) '   (`  /_
     _)``".____,.'"` (_
     )     )'--'(     (
      '---`      `---`
EOF

if [ "$1" == "--install" ]; then
  install_tools
fi

if [ "$1" == "--kms" ]; then
  run_kms_tests
fi

if [ "$1" == "--ekm" ]; then
  run_ekm_tests
fi