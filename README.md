# NAMD_MPIch_UCX_Cuda_container



## Description

Definition file to build NAMD using a base Ubuntu image with MPIch supporting UCX and Cuda with the **mpi-linux-x86_64** option

**Warning: this repository does not include the NAMD application itself**

The user has to obtain the source code `NAMD_3.0_Source.tar.gz` from https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD and put it in the same directory as the Dockerfile

## Build

With `NAMD_3.0_Source.tar.gz` in the same folder as the Dockerfile run:

```
docker build --progress=plain -t namd3 -f Dockerfile .
```

## Coversion to Singularity Image File

```
docker save namd3 -o namd3.tar

singularity build namd3.sif docker-archive://namd3.tar

```

