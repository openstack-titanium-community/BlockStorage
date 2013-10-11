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

class ::Chef::Recipe
  include ::Openstack
end


###############################################################
#               SET CINDER ATTRIBUTES  
###############################################################
#Ip addresses must be assigned in recipes and not in attributes files to avoid conflicts between cookbooks 
# TODO: Change ip addresses to Vip
node.set['openstack']['endpoints']['volume-api']['host'] = node['ipaddress']

###############################################################
#                PERCONA DATABASE DEPENDENCIES
###############################################################

::Chef::Log.info ">>>>>>> Retrieve Database Information <<<<<<<<< "
# Retrieves Database nodes 
# TODO: Change database role name 
# database_cluster = search(:node, "roles:percona")
# database = database_cluster[0] 
dbs = search(:node, "roles:database-server")
db = dbs[0]
# TODO: Test port attribute
# node.set['openstack']['db']['image']['port'] = database["percona"]["server"]["port"]

# TODO: Retrieves database virtual ip from HaProxy 
node.set['openstack']['db']['volume']['host'] = db['ipaddress']

::Chef::Log.info "** Retrieve Database Information End ** "

###############################################################
#                RABBITMQ DEPENDENCIES
###############################################################

::Chef::Log.info ">>>>>>> Retrieve RabbitMq Information <<<<<<<<< "
# TODO: Retrieve RabbitMQ attributes 
rabbitmq_cluster = search(:node, "roles:rabbitmq")
# rabbitmq = rabbitmq_cluster[0]

# node.set["openstack"]["block-storage"]["rabbit"]["username"] = rabbitmq["rabbitmq"]["default_user"]
# node.set["openstack"]["block-storage"]["rabbit"]["vhost"] = rabbitmq["rabbitmq"]["virtualhosts"]
# node.set["openstack"]["block-storage"]["rabbit"]["port"] = rabbitmq["rabbitmq"]["port"]
# node.set["openstack"]["image"]["rabbit"]["host"] = ""

::Chef::Log.info "** Retrieve RabbitMQ Information End ** "

###############################################################
#                    CINDER DATABASE OPERATIONS             
###############################################################
::Chef::Log.info "*** Cinder Common Recipe ***"
::Chef::Log.info "** Cinder DB Registration **"
root_user_use_databag = node['openstack']['db']['root_user_use_databag']

key_path = node["openstack"]["secret"]["key_path"]
user_key = node['openstack']['db']['root_user_key']

# "cinder" is the key name to retrieve cinder user password
# harcoded value in api.rb recipe
service_db_pwd_key = "cinder"
db_passwords_bag = node["openstack"]["secret"]["db_passwords_data_bag"]

service_db_pwd  = secret db_passwords_bag, service_db_pwd_key 
::Chef::Log.info "Retrieve cinder db password #{service_db_pwd}"

db_create_with_user "volume",
                     node["openstack"]["block-storage"]["db"]["username"],
                     service_db_pwd 

::Chef::Log.info "** Cinder DB Registration End **"

###############################################################
#                KEYSTONE DEPENDENCIES 
###############################################################
::Chef::Log.info "** Retrieve Keystone Information **"
# Retrieves Keystone nodes with keystone role
# TODO : Change keystone role name
keystones = search(:node, "roles:keystone-server")
keystone = keystones[0]

# TODO : Test keystone attributes mapping
# Identity API Attributes
# node.set['openstack']['endpoints']['identity-api']['scheme'] = keystone['openstack']['endpoints']['identity-api']['scheme']
# node.set['openstack']['endpoints']['identity-api']['path'] = keystone['openstack']['endpoints']['identity-api']['path']
# node.set['openstack']['endpoints']['identity-api']['port'] = keystone['openstack']['endpoints']['identity-api']['port']
# Keystone virtual ip address should be retrieved from HaProxy
node.set['openstack']['endpoints']['identity-api']['host'] = keystone['ipaddress']

# Identity Admin Attributes
# node.set['openstack']['endpoints']['identity-admin']['scheme'] = keystone['openstack']['endpoints']['identity-admin']['scheme']
# node.set['openstack']['endpoints']['identity-admin']['path'] = keystone['openstack']['endpoints']['identity-admin']['path']
# node.set['openstack']['endpoints']['identity-admin']['port'] = keystone['openstack']['endpoints']['identity-admin']['port']
# TODO: Keystone virtual ip address should be retrieved from HaProxy
node.set['openstack']['endpoints']['identity-admin']['host'] = keystone['ipaddress']

::Chef::Log.info "** Retrieve Keystone Information End **"

###############################################################
#                    GLANCE DEPENDENCIES             
###############################################################
::Chef::Log.info "** Retrieve Keystone Information **"
# Retrieves Glance nodes with Glance role
glance_cluster = search(:node, "roles:haglance")
glance = glance_cluster[0]
glance_ip = glance['ipaddress']

::Chef::Log.info "** Retrieve Glance ip address: #{glance_ip} **"
 
node.set['openstack']['endpoints']['image-api']['scheme'] = glance['openstack']['endpoints']['image-api']['scheme']
node.set['openstack']['endpoints']['image-api']['port'] = glance['openstack']['endpoints']['image-api']['port'] 
node.set['openstack']['endpoints']['image-api']['path'] = glance['openstack']['endpoints']['image-api']['path']
# TODO: Glance virtual ip address should be retrieved from HaProxy
node.set['openstack']['endpoints']['image-api']['host'] = glance['openstack']['endpoints']['image-api']['host']
# node.set['openstack']['endpoints']['image-api']['host'] = glance['ipaddress']
glance_endpoint = node['openstack']['endpoints']['image-api']['host']

::Chef::Log.info "** Retrieve Glance endpoint: #{glance_endpoint} **"
