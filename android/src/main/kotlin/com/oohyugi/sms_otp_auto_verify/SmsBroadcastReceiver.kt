package com.oohyugi.sms_otp_auto_verify

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status

/**
 * Created by oohyugi on 11/03/20.
 */
class SmsBroadcastReceiver : BroadcastReceiver() {

    var mySmsListener: MySmsListener? = null
    fun setSmsListener(listener: MySmsListener) {
        mySmsListener = listener
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
            val extras = intent.extras
            val status = extras!!.get(SmsRetriever.EXTRA_STATUS) as Status

            when (status.statusCode) {
                CommonStatusCodes.SUCCESS -> {
                    // Get SMS message contents
                    val sms: String = extras.get(SmsRetriever.EXTRA_SMS_MESSAGE) as String
                    mySmsListener?.apply {
                        onOtpReceived(message = sms)
                    }


                }

                CommonStatusCodes.TIMEOUT -> {
                    mySmsListener?.onOtpTimeout()

                }
            }

        }
    }

}


interface MySmsListener {
    fun onOtpReceived(message: String?)
    fun onOtpTimeout()

}


