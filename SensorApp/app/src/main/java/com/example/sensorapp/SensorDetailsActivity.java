package com.example.sensorapp;

import androidx.appcompat.app.AppCompatActivity;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.widget.TextView;

public class SensorDetailsActivity extends AppCompatActivity implements SensorEventListener {

    private SensorManager sensorManager;
    private Sensor sensorLight;
    private TextView sensorLightTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_sensor_details);

        String name = getIntent().getExtras().getString(SensorActivity.KEY_EXTRA_SENSOR_NAME);
        sensorLightTextView.setText(name);

        sensorLightTextView = findViewById(R.id.sensor_name);
        sensorLight = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);

        if(name.equals("Goldfish Light sensor") ) {
            sensorLight = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
        } else if(name.equals("Goldfish Pressure sensor")) {
            sensorLight = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE);
        }

        if(sensorLight == null){
            sensorLightTextView.setText(R.string.missing_sensor);
        }
    }

    @Override
    protected void onStart() {
        super.onStart();

        if(sensorLight!=null){
            sensorManager.registerListener(this,sensorLight,SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    @Override
    protected void onStop() {
        super.onStop();

        sensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        int type = event.sensor.getType();
        float value = event.values[0];
        switch (type) {
            case Sensor.TYPE_LIGHT:
            case Sensor.TYPE_AMBIENT_TEMPERATURE:
                sensorValueTextView.setText(String.valueOf(value));
                break;
        }

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }
}