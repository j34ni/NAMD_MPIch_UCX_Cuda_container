# NAMD_MPIch_UCX_Cuda_container

NAMD stands for Nanoscale Molecular Dynamics, it is a high-performance simulation software designed for the simulation of large biomolecular systems, originaly developed by the Theoretical and Computational Biophysics Group at the University of Illinois at Urbana-Champaign, it is widely used in the fields of computational chemistry and molecular biology (https://www.ks.uiuc.edu/Research/namd).

## Description (Dockerfiles)

Definition file to build NAMD using a base Ubuntu image with MPIch supporting UCX and Cuda with the **mpi-linux-x86_64** option (Dockerfile_MPI) and with **multicore-linux-x86_64 --with-single-node-cuda** option (Dockerfile_cuda)

**Warning: this repository does not include the NAMD application itself**

The user has to obtain the source code `NAMD_3.0_Source.tar.gz` from https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD and put it in the same directory as the Dockerfile of his/her choice (or the .def)

### Build (with Docker)

With `NAMD_3.0_Source.tar.gz` in the same folder as the Dockerfile run:

```
docker build --progress=plain -t namd3 -f Dockerfile .
```

### Coversion to Singularity Image File

```
docker save namd3 -o namd3.tar

singularity build namd3.sif docker-archive://namd3.tar

```

# NAMD_ROCm_container

It is also possible to build a container directly as a Singularity Image File (and in this instance with **ROCm** rather than Cuda) instead of using Docker and then converting it

## Description (.def)

Apptainer/Singularity Definition File to build NAMD using a base **rocm/dev-ubuntu-22.04:6.1.2-complete** image suited for AMD Instinct GPUs

### Build (with Singularity or Apptainer)

```
singularity build ubuntu2204_rocm612_namd30.sif ubuntu2204_rocm612_namd30.def
```

### Example of Slurm script for LUMI (2x GPUs & 8x NAMD threads)

```
#!/bin/bash
#SBATCH --job-name=namd3_rocm
#SBATCH --account=project_xxxxxxxxx
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1     
#SBATCH --cpus-per-task=9
#SBATCH --gpus=2
#SBATCH --mem-per-cpu=1GB
#SBATCH --partition standard-g
#SBATCH --exclusive

export SINGULARITY_CACHEDIR=/scratch/project_465000310/.singularity
export SINGULARITY_TMPDIR=/scratch/project_465000310/.singularity

(( namd_threads = SLURM_CPUS_PER_TASK - 1 ))

echo "SLURM_NTASKS "$SLURM_NTASKS
echo "SLURM_JOB_NODELIST "$SLURM_JOB_NODELIST
echo "OMP_NUM_THREADS "${namd_threads}

export IMAGE="ubuntu2204_rocm612_namd30.sif"
echo "Image : "$IMAGE
echo "2 GPUs with ${namd_threads} NAMD threads"
echo "apptainer exec --rocm ubuntu2204_rocm612_namd30.sif namd3 +p ${namd_threads} +devices 0,1..."
echo

cd /scratch/project_xxxxxxxxx/NAMD3

singularity exec --rocm --bind ./apoa1:/apoa1,./tmp:/usr/tmp $IMAGE namd3 +p ${namd_threads} +devices 0,1 /apoa1/apoa1.namd > apoa1_${namd_threads}xthreads_2xgpus.out
```


# Citation

If you use this container recipes and/or related material please kindly cite:

Iaquinta, J. (2024). j34ni/NAMD_MPIch_UCX_Cuda_container: Version 1.0.0 (v1.0.0). Zenodo. https://doi.org/10.5281/zenodo.13303469

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13303469.svg)](https://doi.org/10.5281/zenodo.13303469)
