#
# Cookbook Name:: openstack-block-storage
# Attributes:: default
#
# Copyright 2012, DreamHost
# Copyright 2012, Rackspace US, Inc.
# Copyright 2012-2013, AT&T Services, Inc.
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

########################################################################
# Toggles - These can be overridden at the environment level
default["developer_mode"] = false  # we want secure passwords by default
########################################################################

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default["openstack"]["block-storage"]["custom_template_banner"] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

default["openstack"]["db"]["volume"]["host"] = "10.125.0.15"
default['openstack']['endpoints']['image-api']['host'] = "10.125.0.12"
default['openstack']['endpoints']['image-api']['scheme'] = "http"
default['openstack']['endpoints']['image-api']['port'] = "9292"

#Keystone attributes
default['openstack']['endpoints']['identity-admin']['host'] = "10.125.0.11" 
default['openstack']['endpoints']['identity-admin']['scheme'] = "http" 
default['openstack']['endpoints']['identity-admin']['port'] = "35357"

default['openstack']['endpoints']['identity-api']['host'] = "10.125.0.11" 
default['openstack']['endpoints']['identity-api']['scheme'] = "http" 
default['openstack']['endpoints']['identity-api']['port'] = "5000"
#Cinder Endpoint (Keystone)
default['openstack']['endpoints']['volume-api']['host'] = "10.125.0.11"


 
default["openstack"]["block-storage"]["verbose"] = "False"
default["openstack"]["block-storage"]["debug"] = "False"

# Default lock_path
default["openstack"]["block-storage"]["lock_path"] = "/var/lock/cinder"
# Availability zone/region for the Openstack"]["Block-Storage service
default["openstack"]["block-storage"]["region"] = "RegionOne"

# The name of the Chef role that knows about the message queue server
# that Cinder uses
default["openstack"]["block-storage"]["rabbit_server_chef_role"] = "os-ops-messaging"

# This is the name of the Chef role that will install the Keystone Service API
default["openstack"]["block-storage"]["keystone_service_chef_role"] = "keystone"

# Keystone PKI signing directory. Only written to the filter:authtoken section
# of the api-paste.ini when node["openstack"]["auth"]["strategy"] == "pki"
default["openstack"]["block-storage"]["api"]["auth"]["cache_dir"] = "/var/cache/cinder/api"

# Maximum allocatable gigabytes
# Should equal total backend storage, default is 10TB
default["openstack"]["block-storage"]["max_gigabytes"] = "10000"

# Storage availability zone
# Default is nova
default["openstack"]["block-storage"]["storage_availability_zone"] = "nova"

# Quota definitions
default["openstack"]["block-storage"]["quota_volumes"] = "10"
default["openstack"]["block-storage"]["quota_gigabytes"] = "1000"
default["openstack"]["block-storage"]["quota_driver"] = "cinder.quota.DbQuotaDriver"

# This user's password is stored in an encrypted databag
# and accessed with openstack-common cookbook library's
# user_password routine.  You are expected to create
# the user, pass, vhost in a wrapper rabbitmq cookbook.
default["openstack"]["block-storage"]["rabbit"]["username"] = "guest"
default["openstack"]["block-storage"]["rabbit"]["vhost"] = "/"
default["openstack"]["block-storage"]["rabbit"]["port"] = 5672
default["openstack"]["block-storage"]["rabbit"]["host"] = "10.125.0.19"
default["openstack"]["block-storage"]["rabbit"]["ha"] = false

default["openstack"]["block-storage"]["db"]["username"] = "cinder"

default["openstack"]["block-storage"]["service_tenant_name"] = "service"
default["openstack"]["block-storage"]["service_user"] = "cinder"
default["openstack"]["block-storage"]["service_role"] = "admin"

# Netapp support
default["openstack"]["block-storage"]["netapp"]["protocol"] = "http"
default["openstack"]["block-storage"]["netapp"]["dfm_hostname"] = nil
default["openstack"]["block-storage"]["netapp"]["dfm_login"] = nil
default["openstack"]["block-storage"]["netapp"]["dfm_password"] = nil
default["openstack"]["block-storage"]["netapp"]["dfm_port"] = "8088"
default["openstack"]["block-storage"]["netapp"]["dfm_web_port"] = "8080"
default["openstack"]["block-storage"]["netapp"]["storage_service"] = "storage_service"

# Netapp direct NFS
default["openstack"]["block-storage"]["netapp"]["netapp_server_port"] = "80"
default["openstack"]["block-storage"]["netapp"]["netapp_server_hostname"] = nil
default["openstack"]["block-storage"]["netapp"]["netapp_server_password"] = nil
default["openstack"]["block-storage"]["netapp"]["netapp_server_login"] = nil
default["openstack"]["block-storage"]["netapp"]["export"] = nil
default["openstack"]["block-storage"]["nfs"]["shares_config"] = "/etc/cinder/shares.conf"
default["openstack"]["block-storage"]["nfs"]["mount_point_base"] = "/mnt/cinder-volumes"

# logging attribute
default["openstack"]["block-storage"]["syslog"]["use"] = false
default["openstack"]["block-storage"]["syslog"]["facility"] = "LOG_LOCAL2"
default["openstack"]["block-storage"]["syslog"]["config_facility"] = "local2"

default["openstack"]["block-storage"]["api"]["ratelimit"] = "True"
default["openstack"]["block-storage"]["cron"]["minute"] = '00'

default["openstack"]["block-storage"]["volume"]["state_path"] = "/var/lib/cinder"
default["openstack"]["block-storage"]["volume"]["driver"] = "cinder.volume.driver.ISCSIDriver"
default["openstack"]["block-storage"]["volume"]["volume_group"] = "cinder-volumes"
default["openstack"]["block-storage"]["volume"]["iscsi_helper"] = "tgtadm"

# Ceph/RADOS options
default["openstack"]["block-storage"]["rbd_pool"] = "rbd"
default["openstack"]["block-storage"]["rbd_user"] = nil
default["openstack"]["block-storage"]["rbd_secret_uuid"] = nil

# Cinder Policy defaults
default["openstack"]["block-storage"]["policy"]["context_is_admin"] = '["role:admin"]'
default["openstack"]["block-storage"]["policy"]["default"] = '["rule:admin_or_owner"]'
default["openstack"]["block-storage"]["policy"]["admin_or_owner"] = '["is_admin:True"], ["project_id:%(project_id)s"]'
default["openstack"]["block-storage"]["policy"]["admin_api"] = '["is_admin:True"]'

case platform
when "fedora", "redhat", "centos" # :pragma-foodcritic: ~FC024 - won't fix this
  # operating system user and group names
  default["openstack"]["block-storage"]["user"] = "cinder"
  default["openstack"]["block-storage"]["group"] = "cinder"

  default["openstack"]["block-storage"]["platform"] = {
    "mysql_python_packages" => ["MySQL-python"],
    "postgresql_python_packages" => ["python-psycopg2"],
    "cinder_common_packages" => ["openstack-cinder"],
    "cinder_api_packages" => ["python-cinderclient"],
    "cinder_api_service" => "openstack-cinder-api",
    "cinder_volume_packages" => [],
    "cinder_volume_service" => "openstack-cinder-volume",
    "cinder_scheduler_packages" => [],
    "cinder_scheduler_service" => "openstack-cinder-scheduler",
    "cinder_iscsitarget_packages" => ["scsi-target-utils"],
    "cinder_iscsitarget_service" => "tgtd",
    "cinder_nfs_packages" => ["nfs-utils", "nfs-utils-lib"],
    "package_overrides" => ""
  }
when "suse"
  # operating system user and group names
  default["openstack"]["block-storage"]["user"] = "openstack-cinder"
  default["openstack"]["block-storage"]["group"] = "openstack-cinder"
  default["openstack"]["block-storage"]["platform"] = {
    "mysql_python_packages" => ["python-mysql"],
    "postgresql_python_packages" => ["python-psycopg2"],
    "cinder_common_packages" => ["openstack-cinder"],
    "cinder_api_packages" => ["openstack-cinder-api"],
    "cinder_api_service" => "openstack-cinder-api",
    "cinder_scheduler_packages" => ["openstack-cinder-scheduler"],
    "cinder_scheduler_service" => "openstack-cinder-scheduler",
    "cinder_volume_packages" => ["openstack-cinder-volume"],
    "cinder_volume_service" => "openstack-cinder-volume",
    "cinder_iscsitarget_packages" => ["tgt"],
    "cinder_iscsitarget_service" => "tgtd",
    "cinder_nfs_packages" => ["nfs-utils"]
  }
when "ubuntu"
  # operating system user and group names
  default["openstack"]["block-storage"]["user"] = "cinder"
  default["openstack"]["block-storage"]["group"] = "cinder"
  default["openstack"]["block-storage"]["platform"] = {
    "mysql_python_packages" => ["python-mysqldb"],
    "postgresql_python_packages" => ["python-psycopg2"],
    "cinder_common_packages" => ["cinder-common"],
    "cinder_api_packages" => ["cinder-api", "python-cinderclient"],
    "cinder_api_service" => "cinder-api",
    "cinder_volume_packages" => ["cinder-volume"],
    "cinder_volume_service" => "cinder-volume",
    "cinder_scheduler_packages" => ["cinder-scheduler"],
    "cinder_scheduler_service" => "cinder-scheduler",
    "cinder_iscsitarget_packages" => ["tgt"],
    "cinder_iscsitarget_service" => "tgt",
    "cinder_nfs_packages" => ["nfs-common"],
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
