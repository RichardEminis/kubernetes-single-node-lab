# Single-node Cluster

## Configuration
- Control-plane node is also used as a worker node.
- Default NoSchedule taint was removed from the control-plane.

## Rationale
This setup is used for learning and lab environments to allow workloads to run on a single node.
