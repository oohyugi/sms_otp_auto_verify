package com.oohyugi.sms_otp_auto_verify

import android.app.Activity

import android.content.IntentFilter
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.google.android.gms.auth.api.phone.SmsRetriever;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.common.api.Status;

/** SmsOtpAutoVerifyPlugin */
class SmsOtpAutoVerifyPlugin(private val activity: Activity) : MethodCallHandler, MySmsListener {

    private var mResult: MethodChannel.Result? = null
    private var receiver: SmsBroadcastReceiver? = null
    private var alreadyCalledSmsRetrieve = false

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "sms_otp_auto_verify")
            channel.setMethodCallHandler(SmsOtpAutoVerifyPlugin(registrar.activity()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getAppSignature" -> {
                val signature = AppSignatureHelper(this.activity).getAppSignatures()[0]
                result.success(signature)
            }
            "startListening" -> {
                this.mResult = result
                receiver = SmsBroadcastReceiver()
                startListening()

            }
            "stopListening" -> {
                alreadyCalledSmsRetrieve = false
                unregister()
            }
            else -> result.notImplemented()
        }
    }
   

    private fun startListening() {
        val client = SmsRetriever.getClient(this.activity /* context */)
        val task = client.startSmsRetriever()
        task.addOnSuccessListener {
            // Successfully started retriever, expect broadcast intent
            Log.e(javaClass::getSimpleName.name, "task started")
            receiver?.setSmsListener(this)
            this.activity.registerReceiver(receiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))

        }


    }

    private fun unregister() {
        this.activity.unregisterReceiver(receiver)
    }

    override fun onOtpReceived(message: String?) {
        Log.e("sms", message)

        message?.let {
            if (!alreadyCalledSmsRetrieve) {
                mResult?.success(it)
                alreadyCalledSmsRetrieve = true
            }
        }

    }

    override fun onOtpTimeout() {

    }


}
