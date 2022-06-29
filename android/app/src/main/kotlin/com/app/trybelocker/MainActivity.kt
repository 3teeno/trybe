package com.app.trybelocker

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        try {
            val info: PackageInfo = packageManager.getPackageInfo(
                    packageName,  //Or replace to your package name directly, instead getPackageName() "com.your.app"
                    PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md: MessageDigest = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                Log.e("KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT))
            }
        } catch (e: PackageManager.NameNotFoundException) {
        } catch (e: NoSuchAlgorithmException) {
        }
    }
}
