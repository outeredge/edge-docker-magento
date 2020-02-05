# edge-docker-magento
Magento running on Docker. Plays nicely with [dredger](https://github.com/outeredge/dredger). Designed for development use only.

## Configuration Options
Most configuration can be done with environment variables. Here are the available options;

| Environment       | Default | Description |
| -------------     | ------- | --- |
| APPLICATION_ENV   | dev      | When run, the container will copy `app/etc/local.{APPLICATION_ENV}.xml` to `local.xml`. The default `dev` also enables Magento developer mode and PHP error display |
| ENABLE_CRON       | On      | Enables the Magento cron job to run every 5 minutes |
| ADDITIONAL_STORES | -       | Comma separated list of Magento store codes and Nginx server_name's in the format `MAGE_RUN_CODE:server_name`, i.e. `test_view:test.co.uk` or using a regex `test_view:~test` which would switch Magento to the `test_view` store if the domain name contained the word `test` |

See [edge-docker-php](https://github.com/outeredge/edge-docker-php) for additional options such as SSL, SMTP and PHP  configuration.
