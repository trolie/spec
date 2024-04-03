Feature: Submit Forecast

  @skip
  Scenario Outline: Late submissions
    Given the wall clock time at the server is <server_time>
    #And the server's forecast window deadline offset is <deadline_offset>
    But the forecast submission is for <forecast_start>
    When the client submits the forecast
    Then the server responds with 409 conflict
    Examples:
        | server_time          | forecast_start       |
        | 2025-01-01T01:00:00Z | 2025-01-01T00:00:00Z |
