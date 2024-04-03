from datetime import datetime, timezone, timedelta
import pytest
from pytest_bdd import scenarios, given, when, then, parsers

scenarios("../features/forecasting-profile/submit-forecast.feature")

@pytest.fixture
def request_headers():
    return {"X-TROLIE-Testing": "true"}

@pytest.fixture
def forecast_submittal():
  now = datetime.now(timezone(timedelta(hours=5)))
  an_hour_from_now = now + datetime.timedelta(hours=1)
  top_of_hour_from_now = datetime.fromisoformat(an_hour_from_now.isoformat(timespec='hours'))
  return {"forecast_start": top_of_hour_from_now.isoformat() }

@given(parsers.cfparse("the wall clock time at the server is {server_time:datetime}"))
def set_server_time_header(server_time):
  request_headers["X-TROLIE-Testing-Current-DateTime"] = server_time

@given(parsers.cfparse("the forecast submission is for {forecast_start:datetime}"))
def set_first_forecast_hour(forecast_start):
  pass
