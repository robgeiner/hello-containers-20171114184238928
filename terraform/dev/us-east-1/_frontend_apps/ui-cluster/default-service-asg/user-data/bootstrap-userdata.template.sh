#!/bin/bash
/usr/local/sbin/s3get -f ${bootstrap_bucket_name}/cogads-validator.pem -d /etc/chef
/usr/local/sbin/write_chef_config -t ${bootstrap_bucket_name}/client.rb.template -c https://chef.grid.weather.com/organizations/cogads -a cogads-validator -p ${node_name_prefix}-${environment}
cat >/etc/chef/first-boot.json <<EOL
{"run_list":["role[${chef_role}]", "recipe[platform-autoscaling::asghost]"]}
EOL

installed_chef_version=$(/usr/bin/rpm -q --queryformat '%{VERSION}' chef 2>/dev/null)
if [[ "$installed_chef_version" != "${chef_version}" ]]; then
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- -v ${chef_version}
fi

chef-client -j /etc/chef/first-boot.json -E ${chef_environment} -K /etc/chef/cogads-validator.pem
