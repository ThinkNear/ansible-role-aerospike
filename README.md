Ansible Role: Aerospike
=========

[![Apache 2.0](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://raw.githubusercontent.com/DigitalSlideArchive/ansible-role-vips/master/LICENSE)
[![Build Status](https://travis-ci.org/ThinkNear/ansible-role-aerospike.svg?branch=master)](https://travis-ci.org/ThinkNear/ansible-role-aerospike)

An Ansible role that installs, configures, and runs Aerospike on CentOS and Amazon Linux.

Requirements
------------

The server must run CentOS or Amazon Linux.

This requires Ansible v2.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml):

    aerospike_enabled_on_boot: true

Controls enabling aerospike to start on boot.

    aerospike_version: 3.7.4
    aerospike_tools_version: 3.7.3

Controls the version of Aerospike server and tools, respectively. 
See [Aerospike releases](http://www.aerospike.com/download/server/notes.html) for complete list.

    aerospike_version_downgrade: false

If you are downgrading the installed version to a lower version, then set `aerospike_version_downgrade` to `true`.

    aerospike_source_directory: /usr/local/src
    
Controls the download directory for the Aerospike package.

    aerospike_download_url:
        https://www.aerospike.com/download/server/{{ aerospike_version }}/artifact/el6
        
Controls the download URL used to fetch the archived Aerospike release.

    aerospike_package_name: aerospike-server-community-{{ aerospike_version }}-el6
    
Controls the archived name of the Aerospike release.

    aerospike_rpm_name: aerospike-server-community-{{ aerospike_version }}-1.el6.x86_64.rpm
    
Controls the expected name of the unarchived Aerospike server package.

    aerospike_tools_rpm_name: aerospike-tools-{{ aerospike_tools_version }}-1.el6.x86_64.rpm
    
Controls the expected name of the unarchived Aerospike tools package.

    aerospike_cluster_size: 1

Controls the expected number of nodes in the Aerospike server cluster.

### Using a managed configuration file

    aerospike_use_managed_conf: true

Controls overwriting the existing configuration file. 
Set to `false` if you are using your own configuration file.

**All defaults below apply to a managed configuration file.**

    aerospike_namespaces:
      - name: default

Controls namespace configuration of the Aerospike server.
See [Aerospike namespace configuration](http://www.aerospike.com/docs/operations/configure/namespace/) for details.

You can list multiple namespaces with file, memory, or device storage engines.

    aerospike_namespaces:
      - name: device_objects
        memory_size: 8G
        storage_engine:
          devices:
            - /dev/sdb
            - /dev/dsc
          scheduler_mode: noop
          write_block_size: 128K
      - name: file_objects
        storage_engine: 
          files:
            - /opt/aerospike/data/1
            - /opt/aerospike/data/2
          data_in_memory: true
       - name: memory_objects

Above is an example of configuring 3 namespaces using attached devices, files, and memory.

    aerospike_service_threads: 4

Controls the number of threads receiving client requests on the network interface.
[service-threads Docs](http://www.aerospike.com/docs/reference/configuration/#service-threads)

    aerospike_transaction_queues: 4

Controls the number of transaction queues managing client requests.
Service threads will dispatch transactions into those queues.
[transaction-queues Docs](http://www.aerospike.com/docs/reference/configuration/#transaction-queues)

    aerospike_transaction_threads: 4
    
Controls the number of threads per transaction queue. 
Those threads will consume the requests from the the transaction queues.
[transaction-threads Docs](http://www.aerospike.com/docs/reference/configuration/#transaction-threads-per-queue)

    aerospike_mesh_seed_addresses:
      - 127.0.0.1

Controls the list of mesh addresses of all nodes in the heartbeat cluster. Applies only when the node is mesh
[mesh-seed-address-port Docs](http://www.aerospike.com/docs/reference/configuration/#mesh-seed-address-port)

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - ThinkNear.aerospike

Testing
-------

Travis runs the test playbook against Docker containers.

To run the same tests locally:

1. Install [Docker Toolbox](https://www.docker.com/products/docker-toolbox)

2. Create a machine

    ```sh
    docker-machine create
    ```

3. Connect your shell to the new machine

    ```sh
    eval "$(docker-machine env default)"
    ```

4. Run the `docker_test.sh` script with the target platform.

    ```sh
    ./test/docker_test.sh centos7
    ```

License
-------

ALv2

Author Information
------------------

This role was created in 2016 by Thinknear. 
http://thinknear.com
