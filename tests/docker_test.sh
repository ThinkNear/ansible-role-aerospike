#!/usr/bin/env bash

case "$1" in 
    centos7)
        distribution=centos
        version=7
        init=/usr/lib/systemd/systemd
        temp_dir=$(mktemp -d "${TMPDIR:-/tmp}zombie.XXXXXXXXX")
        run_opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup --volume=${temp_dir}:/run"
        SITE=test
        ;;

    centos6)
        distribution=centos
        version=6
        init=/sbin/init
        run_opts="--privileged"
        SITE=test
        ;;

    *)
        echo $"Usage: $0 {centos7|centos6}"
        exit 1
esac


docker pull ${distribution}:${version}

docker build --rm=true --file=tests/Dockerfile.${distribution}-${version} --tag=${distribution}-${version}:ansible tests

container_id=$(mktemp "${TMPDIR:-/tmp}zombie.XXXXXXXXX")

docker run --detach --volume=${PWD}:/etc/ansible/roles/role_under_test:ro ${run_opts} ${distribution}-${version}:ansible ${init} > ${container_id}

docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/${SITE}.yml --syntax-check

docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/${SITE}.yml

docker exec "$(cat ${container_id})" ansible-playbook /etc/ansible/roles/role_under_test/tests/${SITE}.yml \
    | grep -q 'changed=0.*failed=0' \
    && (echo 'Idempotence test: pass' && exit 0) \
    || (echo 'Idempotence test: fail' && exit 1)

docker stop "$(cat ${container_id})"
