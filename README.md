# pangeo-envs
Environments for our pangeo deployment

## Dont merge into master.

Each branch is a different environment. Tagged branches go to the stable environment all untagged pushes go to the dev environment.

## Auto build 
Build on travis will require the outputs from `scripts/setup_az_sp.sh`. You will need to have the Azure CI installed and logged in.
