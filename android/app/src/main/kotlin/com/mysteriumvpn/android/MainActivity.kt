package com.mysteriumvpn.android

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import java.io.File

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        clearVulkanCache()
        super.onCreate(savedInstanceState)
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
