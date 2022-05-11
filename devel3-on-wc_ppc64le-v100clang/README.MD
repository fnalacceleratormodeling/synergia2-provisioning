# Build synergia2 with CUDA backend for Kokkos on a ppc64le node on wilson cluster, using Clang as the CUDA compiler.

The clang compiler is able to compile CUDA code (i.e. generate NVPTX assembly directly from CUDA sources) as explained [here](https://llvm.org/docs/CompileCudaWithLLVM.html). Harnessing this capability allows one to use a single compiler for to compiler both host and device code, and in practice reduces the number of flags (like `--host-only`) otherwise needed when using the kokkos-nvcc-wrapper as the main compiler. Recent CMake versions (3.18+) allow one to set CUDA as a project language and to set the CUDA compiler separately. 

On WC, a spack instance containing LLVM-14.0.3 and all the dependencies of synergia2, except for kokkos, is available at `/wclustre/accelsim/powerpc/spack`. Source the script `env.sh` to load the compiler and the packages into your environment. Kokkos has been built using Clang-14.0.3 and cuda-10.2.89 at `/wclustre/accelsim/powerpc/kokkos/install`, with clang as the CUDA compiler. Additional flags used include `-DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"` and `-DCMAKE_CXX_FLAGS="-stdlib=libc++"`.

With all dependencies in place, one can now build synergia2 via :
```
cmake -B $(pwd)/build -DENABLE_CUDA=ON -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CXX_FLAGS="-stdlib=libc++" -DBUILD_PYTHON_BINDINGS=ON -DUSE_EXTERNAL_KOKKOS=ON -DUSE_EXTERNAL_PYBIND11=ON -DUSE_EXTERNAL_CEREAL=ON -DCMAKE_CUDA_COMPILER=clang++ -DCMAKE_PREFIX_PATH="/wclustre/accelsim/powerpc/kokkos/install;/usr/local/cuda-10.2"
```

Run a the `fodo_cxx` using the run.sh script.
