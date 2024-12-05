# RabbitMQ Chaos API

Simple HTTP API to trigger internal issues in RabbitMQ such as Channels closing, connections closing, frame errors etc.

## API

### Trigger an experiment

`http://localhost:8080/api/v1/experiments` (externalize port)

#### Method: POST
You can find the available experiments in the `src` folder - by the `chaos_experiment.erl` module.
```json
{
    "experiment": "chaos_close_channels" | "chaos_close_connections" | "chaos_unexpected_frame",
    "metadata": {
        "percentage": 0-100
    }
}
```
