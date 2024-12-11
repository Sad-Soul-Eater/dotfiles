#!/usr/bin/env bash

USER_FLAGS=(
  '--enable-parallel-downloading'

  # '--disable-gpu-driver-bug-workarounds'
  # '--ignore-gpu-blocklist'
  '--enable-zero-copy'
  '--enable-gpu-compositing'
  '--enable-gpu-rasterization'
  '--enable-native-gpu-memory-buffers'
  '--enable-oop-rasterization'
  '--canvas-oop-rasterization'
)

ENABLE_FEATURES=(
  'CanvasOopRasterization'

  'TouchpadOverscrollHistoryNavigation'
  'MiddleClickAutoscroll'
)

if [[ "$WAYLAND" == "1" ]]; then
  USER_FLAGS+=(
    '--ozone-platform-hint=auto'
  )
fi

if [[ "$ACCELERATED_VIDEO" == "1" ]]; then
  ENABLE_FEATURES+=(
    'AcceleratedVideoDecodeLinuxZeroCopyGL'
    'AcceleratedVideoEncoder'

    'VaapiVideoDecoder'
    'VaapiVideoEncoder'
    'VaapiIgnoreDriverChecks'
    'UseMultiPlaneFormatForHardwareVideo'
    'PlatformHEVCDecoderSupport'
  )
fi

if [[ "$VULKAN" == "1" ]]; then
  USER_FLAGS+=(
    '--use-vulkan'
    '--use-gl=angle'
    '--use-angle=vulkan'
  )
  ENABLE_FEATURES+=(
    'Vulkan'
    'VulkanFromANGLE'
    'DefaultANGLEVulkan'
  )
fi

printf -v ENABLE_FEATURES_STR '%s,' "${ENABLE_FEATURES[@]}"
USER_FLAGS+=(
  "--enable-features=${ENABLE_FEATURES_STR%,}"
)

EXECUTABLE="$1" && shift

exec $EXECUTABLE "${USER_FLAGS[@]}" "$@"
