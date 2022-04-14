# nv_gpu_probe

This is a little utility derived from the Kokkos cmake scripts to
probe an nVidia GPU and tell you what it's architecture is.

Build it with nvcc_wrapper.

    nvcc_wrapper -o nv_gpu_probe nv_gpu_probe.cc

Run it on WC with srun command like:

    srun -A accelsim -p gpu_gce -N 1 -n 1 --gres=gpu:1 nv_gpu_probe

with sample like:

```
device: 0 properties major.minor: 6.0
Add these arguments to the CMake command:
  -DCMAKE_CXX_FLAGS="-arch=sm_60" \
 -DKokkos_ARCH_PASCAL60=ON \
```



