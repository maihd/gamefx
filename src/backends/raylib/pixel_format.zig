pub enum(u32) {
    none,                       // 
    uncompressed_grayscale = 1, // 8    bit per pixel (no alpha)
    uncompressed_gray_alpha,    // 8*2  bit per pixel (2 channels)
    uncompressed_r5g6b5,        // 16   bit per pixel
    uncompressed_r8g8b8,        // 24   bit per pixel
    uncompressed_r5g5b5a1,      // 16   bit per pixel (1 bit alpha)
    uncompressed_r4g4b4a4,      // 16   bit per pixel (4 bit alpha)
    uncompressed_r8g8b8a8,      // 32   bit per pixel
    uncompressed_r32,           // 32   bit per pixel (1 channel - float)
    uncompressed_r32g32b32,     // 32*3 bit per pixel (3 channels - float)
    uncompressed_r32g32b32a32,  // 32*4 bit per pixel (4 channels - float)
    compressed_dxt1_rgb,        // 4    bit per pixel (no alpha)
    compressed_dxt1_rgba,       // 4    bit per pixel (1 bit alpha)
    compressed_dxt3_rgba,       // 8    bit per pixel
    compressed_dxt5_rgba,       // 8    bit per pixel
    compressed_etc1_rgb,        // 4    bit per pixel
    compressed_etc2_rgb,        // 4    bit per pixel
    compressed_etc2_eac_rgba,   // 8    bit per pixel
    compressed_pvrt_rgb,        // 4    bit per pixel
    compressed_pvrt_rgba,       // 4    bit per pixel
    compressed_astc_4x4_rgba,   // 8    bit per pixel
    compressed_astc_8x8_rgba,   // 2    bit per pixel
};