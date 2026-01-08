package com.mysteriumvpn.android

import android.os.Bundle
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import java.io.File

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Clear cache on devices known to have Vulkan crashes
        if (isProblematicDevice()) {
            clearVulkanCache()
        }
        super.onCreate(savedInstanceState)
    }
    
    private fun isProblematicDevice(): Boolean {
        // Target Snapdragon chipsets with known Vulkan driver issues
        val problematicChipsets = listOf(
            "sdm845",  // Snapdragon 845
            "sm8150",  // Snapdragon 855
            "sm8250"   // Snapdragon 865
        )
        
        return problematicChipsets.any { 
            Build.HARDWARE.contains(it, ignoreCase = true) ||
            Build.BOARD.contains(it, ignoreCase = true) ||
            Build.DEVICE.contains(it, ignoreCase = true)
        }
    }
    
    private fun clearVulkanCache() {
        try {
            val cacheDirs = listOf(
                File(applicationContext.cacheDir, "vulkan_shader_cache"),
                File(applicationContext.cacheDir, "code_cache/vulkan"),
                File(applicationContext.cacheDir, "VkPipelineCache"),
                File(applicationContext.cacheDir, "gpu_cache")
            )
            
            cacheDirs.forEach { cacheDir ->
                if (cacheDir.exists()) {
                    cacheDir.deleteRecursively()
                }
            }
            
            applicationContext.cacheDir.listFiles()?.forEach { file ->
                if (file.isFile && file.name.endsWith(".vkcache")) {
                    file.delete()
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
