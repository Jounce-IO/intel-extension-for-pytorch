# Use Miniconda base image
FROM continuumio/miniconda3:23.10.0-1

# Set metadata
LABEL authors="jounce"

# Set the working directory
WORKDIR /code

# Update and install dependencies in a single RUN to reduce layers
RUN apt-get update && \
    apt-get install -y --reinstall wget libp11-kit0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV CONDA_PREFIX /opt/conda
ENV PATH $CONDA_PREFIX/bin:$PATH

# Download and run the compile_bundle script
RUN wget https://github.com/intel/intel-extension-for-pytorch/raw/v2.1.100%2Bcpu/scripts/compile_bundle.sh
RUN bash compile_bundle.sh


# Install PyTorch requirements
RUN conda install zlib zstd libxml2 libgomp && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu


ENV LLVM_ROOT /code/llvm-release
ENV LLVM_DIR $LLVM_ROOT/lib/cmake/llvm
ENV PATH ${LLVM_ROOT}/bin:$PATH
ENV LD_LIBRARY_PATH $LLVM_ROOT/lib:$CONDA_PREFIX:$LD_LIBRARY_PATH
ENV DNNL_GRAPH_BUILD_COMPILER_BACKEND 1

# remote installation
RUN pip uninstall -y intel-extension-for-pytorch

# Clone and set up Intel Extension for PyTorch
RUN cd intel-extension-for-pytorch && \
    pip install -r requirements.txt && \
    python3 setup.py develop

# Set default command
ENTRYPOINT ["/bin/bash"]