package com.example.best_flutter_ui_templates

import android.app.Activity
import android.content.Intent
import android.speech.RecognizerIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "ams.native.speech"
    private val requestCodeSpeech = 101
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            if (call.method == "startListening") {
                pendingResult = result
                startSpeechRecognition()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startSpeechRecognition() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(
            RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
        )
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Speak your issue")
        startActivityForResult(intent, requestCodeSpeech)
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == requestCodeSpeech) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                val speechResult = data.getStringArrayListExtra(
                    RecognizerIntent.EXTRA_RESULTS
                )
                pendingResult?.success(speechResult?.firstOrNull())
            } else {
                pendingResult?.success(null)
            }
            pendingResult = null
        }
    }
}
