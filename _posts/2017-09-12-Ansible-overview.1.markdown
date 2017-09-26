---
layout: post
title: Ansible overview
date:   2017-09-11 12:00:00 -0500
categories: cloud
excerpt_separator: <!--more-->
---

Ansible is an open source automation engine which can automate provisioning, configuration, and application deployment written in Python.

The automation engine takes it's name from the Instantaneous communications system that is present the in the popular science-fiction novel *Ender's Game*.

<!--more-->


# Up and running

Installing Ansible on OSX is fairly painless. First, ensure pip (Python package manager) is installed.

```
sudo easy_install pip
```

Next, use pip to install Ansible.

```
sudo pip install ansible
```

Ansible uses SSH to communicate to remote machines, so it is nessesary that the remote machines have a copy of your public SSH key, in `authroized_keys`.

# Ansible hosts

On the Ansible control machine (most likely whatever computer you are reading this blog from), the inventory file is located at `/etc/ansible/hosts`. This file contains the addresses of the remote machines. An example file is below:

```
192.0.2.50
www.footprints.com
kibana.footprints.com
logstash.footprints.com
elasticsearch.footprints.com
```

Once the configurations are complete, we can now run commands on the remote machines. This is simple using the ansible command line utilities.  Here we are going to log "hello" to all the remote machines in the inventory file.

```
ansible all -a "/bin/echo hello"
```

The above command opens a SSH connection to each maching and runs `/bin/echo hello` on each of the machines in the inventory file. 

The inventory file can be organize by groups using a bracket notation.

```
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

Variables can also be assigned to the hosts in the inventory file that can later be used in Ansible playbooks. Playbooks are Ansible's configuration, deployment and orchestration language. 

Here is an example playbook with only a single play (playbooks can be composed of many plays).

```
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running (and enable it at boot)
    service: name=httpd state=started enabled=yes
  handlers:
    - name: restart apache
      service: name=httpd state=restarted
```

And here is another example which also writes a configuration file.

```
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum:
      name: httpd
      state: latest
  - name: write the apache config file
    template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running
    service:
      name: httpd
      state: started
  handlers:
    - name: restart apache
      service:
        name: httpd
        state: restarted
```

# Provisioning Server then Databases

```
---
- hosts: webservers
  remote_user: root

  tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf

- hosts: databases
  remote_user: root

  tasks:
  - name: ensure postgresql is at the latest version
    yum: name=postgresql state=latest
  - name: ensure that postgresql is started
    service: name=postgresql state=started
```

# Directory Layout

```
production                # inventory file for production servers
staging                   # inventory file for staging environment

group_vars/
   group1                 # here we assign variables to particular groups
   group2                 # ""
host_vars/
   hostname1              # if systems need specific variables, put them here
   hostname2              # ""

library/                  # if any custom modules, put them here (optional)
module_utils/             # if any custom module_utils to support modules, put them here (optional)
filter_plugins/           # if any custom filter plugins, put them here (optional)

site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```


# EC2 Provisioning examples

```

# Basic provisioning example
- ec2:
    key_name: mykey
    instance_type: t2.micro
    image: ami-123456
    wait: yes
    group: webserver
    count: 3
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

# Advanced example with tagging and CloudWatch
- ec2:
    key_name: mykey
    group: databases
    instance_type: t2.micro
    image: ami-123456
    wait: yes
    wait_timeout: 500
    count: 5
    instance_tags:
       db: postgres
    monitoring: yes
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

# Single instance with additional IOPS volume from snapshot and volume delete on termination
- ec2:
    key_name: mykey
    group: webserver
    instance_type: c3.medium
    image: ami-123456
    wait: yes
    wait_timeout: 500
    volumes:
      - device_name: /dev/sdb
        snapshot: snap-abcdef12
        volume_type: io1
        iops: 1000
        volume_size: 100
        delete_on_termination: true
    monitoring: yes
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

# Single instance with ssd gp2 root volume
- ec2:
    key_name: mykey
    group: webserver
    instance_type: c3.medium
    image: ami-123456
    wait: yes
    wait_timeout: 500
    volumes:
      - device_name: /dev/xvda
        volume_type: gp2
        volume_size: 8
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes
    count_tag:
      Name: dbserver
    exact_count: 1

# Multiple groups example
- ec2:
    key_name: mykey
    group: ['databases', 'internal-services', 'sshable', 'and-so-forth']
    instance_type: m1.large
    image: ami-6e649707
    wait: yes
    wait_timeout: 500
    count: 5
    instance_tags:
        db: postgres
    monitoring: yes
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

# Multiple instances with additional volume from snapshot
- ec2:
    key_name: mykey
    group: webserver
    instance_type: m1.large
    image: ami-6e649707
    wait: yes
    wait_timeout: 500
    count: 5
    volumes:
    - device_name: /dev/sdb
      snapshot: snap-abcdef12
      volume_size: 10
    monitoring: yes
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

# Dedicated tenancy example
- local_action:
    module: ec2
    assign_public_ip: yes
    group_id: sg-1dc53f72
    key_name: mykey
    image: ami-6e649707
    instance_type: m1.small
    tenancy: dedicated
    vpc_subnet_id: subnet-29e63245
    wait: yes

# Spot instance example
- ec2:
    spot_price: 0.24
    spot_wait_timeout: 600
    keypair: mykey
    group_id: sg-1dc53f72
    instance_type: m1.small
    image: ami-6e649707
    wait: yes
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes
    spot_launch_group: report_generators

# Examples using pre-existing network interfaces
- ec2:
    key_name: mykey
    instance_type: t2.small
    image: ami-f005ba11
    network_interface: eni-deadbeef

- ec2:
    key_name: mykey
    instance_type: t2.small
    image: ami-f005ba11
    network_interfaces: ['eni-deadbeef', 'eni-5ca1ab1e']

# Launch instances, runs some tasks
# and then terminate them

- name: Create a sandbox instance
  hosts: localhost
  gather_facts: False
  vars:
    key_name: my_keypair
    instance_type: m1.small
    security_group: my_securitygroup
    image: my_ami_id
    region: us-east-1
  tasks:
    - name: Launch instance
      ec2:
         key_name: "{{ keypair }}"
         group: "{{ security_group }}"
         instance_type: "{{ instance_type }}"
         image: "{{ image }}"
         wait: true
         region: "{{ region }}"
         vpc_subnet_id: subnet-29e63245
         assign_public_ip: yes
      register: ec2

    - name: Add new instance to host group
      add_host:
        hostname: "{{ item.public_ip }}"
        groupname: launched
      with_items: "{{ ec2.instances }}"

    - name: Wait for SSH to come up
      wait_for:
        host: "{{ item.public_dns_name }}"
        port: 22
        delay: 60
        timeout: 320
        state: started
      with_items: "{{ ec2.instances }}"

- name: Configure instance(s)
  hosts: launched
  become: True
  gather_facts: True
  roles:
    - my_awesome_role
    - my_awesome_test

- name: Terminate instances
  hosts: localhost
  connection: local
  tasks:
    - name: Terminate instances that were previously launched
      ec2:
        state: 'absent'
        instance_ids: '{{ ec2.instance_ids }}'

# Start a few existing instances, run some tasks
# and stop the instances

- name: Start sandbox instances
  hosts: localhost
  gather_facts: false
  connection: local
  vars:
    instance_ids:
      - 'i-xxxxxx'
      - 'i-xxxxxx'
      - 'i-xxxxxx'
    region: us-east-1
  tasks:
    - name: Start the sandbox instances
      ec2:
        instance_ids: '{{ instance_ids }}'
        region: '{{ region }}'
        state: running
        wait: True
        vpc_subnet_id: subnet-29e63245
        assign_public_ip: yes
  roles:
    - do_neat_stuff
    - do_more_neat_stuff

- name: Stop sandbox instances
  hosts: localhost
  gather_facts: false
  connection: local
  vars:
    instance_ids:
      - 'i-xxxxxx'
      - 'i-xxxxxx'
      - 'i-xxxxxx'
    region: us-east-1
  tasks:
    - name: Stop the sandbox instances
      ec2:
        instance_ids: '{{ instance_ids }}'
        region: '{{ region }}'
        state: stopped
        wait: True
        vpc_subnet_id: subnet-29e63245
        assign_public_ip: yes

#
# Start stopped instances specified by tag
#
- local_action:
    module: ec2
    instance_tags:
        Name: ExtraPower
    state: running

#
# Restart instances specified by tag
#
- local_action:
    module: ec2
    instance_tags:
        Name: ExtraPower
    state: restarted

#
# Enforce that 5 instances with a tag "foo" are running
# (Highly recommended!)
#

- ec2:
    key_name: mykey
    instance_type: c1.medium
    image: ami-40603AD1
    wait: yes
    group: webserver
    instance_tags:
        foo: bar
    exact_count: 5
    count_tag: foo
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

#
# Enforce that 5 running instances named "database" with a "dbtype" of "postgres"
#

- ec2:
    key_name: mykey
    instance_type: c1.medium
    image: ami-40603AD1
    wait: yes
    group: webserver
    instance_tags:
        Name: database
        dbtype: postgres
    exact_count: 5
    count_tag:
        Name: database
        dbtype: postgres
    vpc_subnet_id: subnet-29e63245
    assign_public_ip: yes

#
# count_tag complex argument examples
#

    # instances with tag foo
    count_tag:
        foo:

    # instances with tag foo=bar
    count_tag:
        foo: bar

    # instances with tags foo=bar & baz
    count_tag:
        foo: bar
        baz:

    # instances with tags foo & bar & baz=bang
    count_tag:
        - foo
        - bar
        - baz: bang
```



