package com.example.nammavaru;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "payment";

    private MethodChannel.Result callResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       // GeneratedPluginRegistrant.registerWith(MainActivity.this);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("launchUpi")) {
                            Uri uri = Uri.parse(call.argument("url").toString());
                            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                            startActivityForResult(intent,1);
                            Log.d("Call", "onMethodCall: launchUpi");
                            callResult = result;
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        Log.d("Result","Data :"+data);
        if(data!=null && callResult!=null) {
            String res = data.getStringExtra("response");
            String search = "SUCCESS";
            if (res.toLowerCase().contains(search.toLowerCase())) {
                callResult.success("Success");
            } else {
                callResult.success("Failed");
            }
        }else{
            Log.d("Result","Data = null (User canceled)");
            callResult.success("User Cancelled");
        }
        super.onActivityResult(requestCode,resultCode,data);
    }
}
