import os
import time
from prometheus_client import start_http_server, Gauge
import requests

class AppMetrics:
    """
    Representation of Prometheus metrics and loop to fetch and transform
    application metrics into Prometheus metrics.
    """

    def __init__(self, app_port=80, device_ip="localhost", polling_interval_seconds=5):
        self.app_port = app_port
        self.device_ip = device_ip
        self.polling_interval_seconds = polling_interval_seconds

        # Prometheus metrics to collect
        self.awair_score = Gauge("awair_score", "Awair Score (0-100)")
        self.awair_voc_h2_raw = Gauge("awair_voc_h2_raw", "A unitless value that represents the Hydrogen gas signal from which the TVOC sensor partially derives its TVOC output.")
        self.awair_voc_ethanol_raw = Gauge("awair_voc_ethanol_raw", "A unitless value that represents the Ethanol gas signal from which the TVOC sensor partially derives its TVOC output.")
        self.awair_voc_baseline = Gauge("awair_voc_baseline", "A unitless value that represents the baseline from which the TVOC sensor partially derives its TVOC output.")
        self.awair_voc = Gauge("awair_voc", "Total Volatile Organic Compounds (ppb)")
        self.awair_temp = Gauge("awair_temp", "Dry bulb temperature (ºC)")
        self.awair_pm25 = Gauge("awair_pm25", "Particulate matter less than 2.5 microns in diameter (µg/m³)")
        self.awair_pm10 = Gauge("awair_pm10", "Estimated particulate matter less than 10 microns in diameter (µg/m³ - calculated by the PM2.5 sensor)")
        self.awair_humidity = Gauge("awair_humidity", "Relative Humidity (%)")
        self.awair_dew_point = Gauge("awair_dew_point", "The temperature at which water will condense and form into dew (ºC)")
        self.awair_co2_est_baseline = Gauge("awair_co2_est_baseline", "A unitless value that represents the baseline from which the TVOC sensor partially derives its estimated (e)CO₂output.")
        self.awair_co2_est = Gauge("awair_co2_est", "Estimated Carbon Dioxide (ppm - calculated by the TVOC sensor)")
        self.awair_co2 = Gauge("awair_co2", "Carbon Dioxide (ppm)")
        self.awair_absolute_humidity = Gauge("awair_absolute_humidity", "Absolute Humidity (g/m³)")
    
    def run_metrics_loop(self):
        """Metrics fetching loop"""

        while True:
            self.fetch()
            time.sleep(self.polling_interval_seconds)

    def fetch(self):
        """
        Get metrics from application and refresh Prometheus metrics with new values.
        """

        # Fetch raw status data from the application
        resp = requests.get(url=f"http://{self.device_ip}:{self.app_port}/air-data/latest")
        status_data = resp.json()

        # Update Prometheus metrics with application metrics
        self.awair_score.set(status_data["score"])
        self.awair_voc_h2_raw.set(status_data["voc_h2_raw"])
        self.awair_voc_ethanol_raw.set(status_data["voc_ethanol_raw"])
        self.awair_voc_baseline.set(status_data["voc_baseline"])
        self.awair_voc.set(status_data["voc"])
        self.awair_temp.set(status_data["temp"])
        self.awair_pm25.set(status_data["pm25"])
        self.awair_pm10.set(status_data["pm10_est"])
        self.awair_humidity.set(status_data["humid"])
        self.awair_dew_point.set(status_data["dew_point"])
        self.awair_co2_est_baseline.set(status_data["co2_est_baseline"])
        self.awair_co2_est.set(status_data["co2_est"])
        self.awair_co2.set(status_data["co2"])
        self.awair_absolute_humidity.set(status_data["abs_humid"])

def main():

    polling_interval_seconds = int(os.getenv("POLLING_INTERVAL_SECONDS", "60"))
    app_port = int(os.getenv("APP_PORT", "80"))
    device_ip = "192.168.10.153"
    exporter_port = int(os.getenv("EXPORTER_PORT", "9877"))

    app_metrics = AppMetrics(
        app_port=app_port,
        device_ip=device_ip,
        polling_interval_seconds=polling_interval_seconds
    )
    start_http_server(exporter_port)
    app_metrics.run_metrics_loop()

if __name__ == '__main__':
    main()