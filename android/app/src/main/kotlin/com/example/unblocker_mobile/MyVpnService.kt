package com.example.unblocker_mobile

import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor

class MyVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP") {
            stopVpn()
            return START_NOT_STICKY
        }

        if (vpnInterface == null) {
            val builder = Builder()
            builder.addAddress("10.0.0.2", 24)
            builder.addRoute("0.0.0.0", 0)
            builder.setSession("UnblockerService")
            vpnInterface = builder.establish()
        }
        return START_STICKY
    }

    private fun stopVpn() {
        try {
            vpnInterface?.close()
        } catch (_: Exception) {}
        vpnInterface = null
        stopSelf()
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }
}
