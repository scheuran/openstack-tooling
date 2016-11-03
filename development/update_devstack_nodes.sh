# Prerequs
# - development happens on a branch != master, changes are commited
# - ssh keys set up for communication with nodes
# - devstack runs under the stack user
# - script resides in the git repo


# list of hostnames/ips that should be updated
# nodes=( hostname1 hostname2 192.168.0.1 )
nodes=( )
# list of devstack services to restart
# services=( q-svc q-agt n-cpu )
services=( )

# get the current local branch to push to the remote nodes
branch=$(git rev-parse --abbrev-ref HEAD)

for node in "${nodes[@]}"; do
    echo "*** Processing node $node"
    ssh stack@$node 'cd /opt/stack/neutron; git checkout master'
    git push $node $branch --force
    ssh stack@$node 'cd /opt/stack/neutron; git checkout '"$branch"

    for service in "${services[@]}"; do
        echo "** restarting service $service"
        ssh stack@$node "screen -X -p $service stuff '^C'"
        ssh stack@$node "screen -X -p $service stuff '!!'"
        #ssh stack@$node "screen -X -p $service  stuff '^[[A''"
        ssh stack@$node "screen -X -p $service  stuff '\r'"  
    done 
done
