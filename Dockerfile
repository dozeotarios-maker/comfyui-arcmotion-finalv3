 # rebuild trigger 2026-05-24 
  FROM runpod/worker-comfyui:5.8.4-base

  # Custom nodes
  RUN git clone https://github.com/rgthree/rgthree-comfy /comfyui/custom_nodes/rgthree-comfy 

  RUN git clone https://github.com/kijai/ComfyUI-segment-anything-2 /comfyui/custom_nodes/ComfyUI-segment-anything-2 \
   && cd /comfyui/custom_nodes/ComfyUI-segment-anything-2 \
   && git checkout 0c35fff5f382803e2310103357b5e985f5437f32 || true
  
  RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes \
   && cd /comfyui/custom_nodes/ComfyUI-KJNodes \
   && git checkout 00da1910634fbf314d407608efb281ae6f7f1ba2 || true
  
  RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite /comfyui/custom_nodes/ComfyUI-VideoHelperSuite \
   && cd /comfyui/custom_nodes/ComfyUI-VideoHelperSuite \
   && git checkout 993082e4f2473bf4acaf06f51e33877a7eb38960 || true
  
  RUN git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess \
   && cd /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess \
   && git checkout 1a35b81a418bbba093356ad19b19bf2a76a24f4e || true

  RUN git clone https://github.com/yolain/ComfyUI-Easy-Use /comfyui/custom_nodes/ComfyUI-Easy-Use \
   && cd /comfyui/custom_nodes/ComfyUI-Easy-Use \
   && git checkout 81c510c06e18dffd4f43518644fc35964c9168ca || true

  RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts /comfyui/custom_nodes/ComfyUI-Custom-Scripts \
   && cd /comfyui/custom_nodes/ComfyUI-Custom-Scripts \
   && git checkout 609f3afaa74b2f88ef9ce8d939626065e3247469 || true

  RUN comfy node install --exit-on-fail comfyui-workflow-encrypt@1.0.0 --mode remote \
   || comfy node install --exit-on-fail comfyui-workflow-encrypt --mode remote

  RUN git clone https://github.com/chflame163/ComfyUI_LayerStyle /comfyui/custom_nodes/ComfyUI_LayerStyle \
   && cd /comfyui/custom_nodes/ComfyUI_LayerStyle \
   && git checkout d94bef1ee5ed3656f5ff1bb2830a4ffd94f40935 || true

  RUN git clone https://github.com/lihaoyun6/ComfyUI-FlashVSR_Ultra_Fast /comfyui/custom_nodes/ComfyUI-FlashVSR_Ultra_Fast \
   && cd /comfyui/custom_nodes/ComfyUI-FlashVSR_Ultra_Fast \
   && git checkout 4820b3f02347bddcbbb9a5a85ab7638fe976366e || true

  RUN git clone https://github.com/kijai/ComfyUI-WanVideoWrapper /comfyui/custom_nodes/ComfyUI-WanVideoWrapper \
   && cd /comfyui/custom_nodes/ComfyUI-WanVideoWrapper \
   && git checkout d18cdb1 || true 

  RUN apt-get update && apt-get install -y --no-install-recommends gcc g++ build-essential python3-dev && rm -rf /var/lib/apt/lists/*

  # Install Python deps for all custom nodes
  RUN for f in /comfyui/custom_nodes/*/requirements.txt; do pip install --no-cache-dir -r "$f" || true; done

  RUN pip install --no-cache-dir runpod boto3 requests

  COPY handler.py /handler.py
  
  # Symlink models from network volume
  RUN rm -rf /comfyui/models && ln -sf /runpod-volume/runpod-slim/ComfyUI/models /comfyui/models
