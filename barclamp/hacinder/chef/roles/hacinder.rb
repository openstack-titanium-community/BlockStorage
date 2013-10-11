name "hacinder"
description "HaCinder Role"
run_list(
        "recipe[python]",
        "recipe[openstack-block-storage::common]",
        "recipe[openstack-block-storage::cinder-common]",
        "recipe[openstack-block-storage::api]",
        "recipe[openstack-block-storage::identity_registration]",
        "recipe[openstack-block-storage::volume]",
        "recipe[openstack-block-storage::scheduler]"
)
default_attributes()
override_attributes()
