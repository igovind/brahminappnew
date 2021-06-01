package com.pujapurohit.brahminapp

import io.flutter.plugin.common.PluginRegistry

object FirebaseCloudMessagingPlugin {
    fun registerWith(pluginRegistry: PluginRegistry) {
        if (alreadyRegisterdWith(pluginRegistry)) return
        registerWith(pluginRegistry)
    }

    private fun alreadyRegisterdWith(pluginRegistry: PluginRegistry): Boolean {
        val key = FirebaseCloudMessagingPlugin::class.java.canonicalName
        if (pluginRegistry.hasPlugin(key)) return true
        pluginRegistry.registrarFor(key)
        return false
    }
}