#!/bin/bash -ex

rpm -ivh http://external-repo.grid.weather.com/grid-yum-repo-0.1.0-1.noarch.rpm
yum install -y s3get chef

mkdir /etc/chef
/usr/local/bin/s3get -region="${region}" s3://${bootstrap_bucket_name}/${chef_organization}-validator.pem | tee /etc/chef/${chef_organization}-validator.pem

cat >/etc/chef/userdata.json  <<EOL
${userdata}
EOL

#echo '{"run_list":["role['${chef_role}']", "recipe[twc-es-proxy::userdata]", "recipe[twc-es-proxy::default]"]}' | tee /etc/chef/first-boot.json

USERDATA=$(cat /etc/chef/userdata.json | tr -d '\r\n' | tr -d ' ')
echo   '{'$USERDATA',"run_list":["role['${chef_role}']", "recipe[iptables::disabled]", "recipe[twc-es-proxy::default]"]}' | tee /etc/chef/first-boot.json

echo 'log_level        :auto
log_location     STDOUT
chef_server_url  "'${chef_server_url}'"
validation_client_name "'${chef_organization}'-validator"' | tee /etc/chef/client.rb

AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone | tr -d '-')
echo "node_name \"${node_name_prefix}-${environment}-$AZ-$((ip route get 8.8.8.8 | awk -F. '{print $(NF-1)$NF;exit}') | sed 's/ //g')\"" | tee -a /etc/chef/client.rb

installed_chef_version=$(/usr/bin/rpm -q --queryformat '%{VERSION}' chef 2>/dev/null)
if [[ "$installed_chef_version" != "${chef_version}" ]]; then
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- -v ${chef_version}
fi

mkdir -p /etc/chef/trusted_certs
curl --silent --show-error --retry 3 --location --output /etc/chef/trusted_certs/opsworks-cm-ca-2016-root.pem https://opsworks-cm-us-east-1-prod-default-assets.s3.amazonaws.com/misc/opsworks-cm-ca-2016-root.pem

chef-client -j /etc/chef/first-boot.json -E ${chef_environment} -K /etc/chef/${chef_organization}-validator.pem
