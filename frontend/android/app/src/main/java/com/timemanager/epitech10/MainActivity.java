package com.timemanager.epitech10;

import com.getcapacitor.BridgeActivity;
import android.os.Bundle; // Import nécessaire pour Bundle
import android.webkit.WebSettings; // Import pour WebView
import android.webkit.WebView; // Import pour WebView
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Autoriser le contenu mixte dans la WebView
        WebView webView = (WebView) this.bridge.getWebView();
        WebSettings webSettings = webView.getSettings();
        webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
    }
}
