#!/bin/bash
/usr/local/sbin/s3get -f sun-${environment}-bootstrap/platform-validator-grid.pem -d /etc/chef
/usr/local/sbin/write_chef_config -t sun-${environment}-bootstrap/client.rb.template -c https://chef.grid.weather.com/organizations/platform -a platform-validator -p ${node_name_prefix}-${environment}
cat >/etc/chef/first-boot.json <<EOL
{"run_list":["role[${chef_role}]", "recipe[platform-autoscaling::asghost]"]}
EOL

installed_chef_version=$(/usr/bin/rpm -q --queryformat '%{VERSION}' chef 2>/dev/null)
if [[ "$installed_chef_version" != "${chef_version}" ]]; then
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- -v ${chef_version}
fi

chef-client -j /etc/chef/first-boot.json -E ${environment}-${region} -K /etc/chef/platform-validator-grid.pem > /tmp/chef-client-bootstrap1.txt

if [ $? != 0 ]; then
  chef-client -j /etc/chef/first-boot.json > /tmp/chef-client-bootstrap2.txt
fi
if [ $? != 0 ]; then
  chef-client -j /etc/chef/first-boot.json > /tmp/chef-client-bootstrap3.txt
fi
if [ $? != 0 ]; then
  chef-client -j /etc/chef/first-boot.json > /tmp/chef-client-bootstrap4.txt
fi
if [ $? != 0 ]; then
  chef-client -j /etc/chef/first-boot.json > /tmp/chef-client-bootstrap5.txt
fi
