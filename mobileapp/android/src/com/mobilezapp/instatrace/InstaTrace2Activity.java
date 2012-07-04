package com.mobilezapp.instatrace;

import android.app.Activity;
import org.apache.cordova.*;

import android.os.Bundle;

public class InstaTrace2Activity extends DroidGap {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        super.setIntegerProperty("loadUrlTimeoutValue", 120000); 
        super.loadUrl("file:///android_asset/www/index.html");
    }
}