# edge-docker-magento
Magento running on Docker. Plays nicely with [dredger](https://github.com/outeredge/dredger). Designed for development use only.

Regularly updated with the latest 2.* and 1.* releases (see tags).

## Configuration Options
Most configuration can be done with environment variables. Here are the available options;

| Environment       | Default | Description |
| -------------     | ------- | --- |
| MAGE_MODE         | -       | Set's the Magento [mode](http://devdocs.magento.com/guides/v2.3/config-guide/bootstrap/magento-modes.html), this is usualy `default` if not set elsewhere |
| MAGE_ENV          | -       | Specify the environment file extension to use (i.e. `env.php.$MAGE_ENV`),  if not set, will look for `env.php.$MAGE_MODE` |
| ENABLE_CRON       | Off     | Enables the Magento cron jobs |
| ADDITIONAL_STORES | -       | Comma separated list of Magento store codes and Nginx server_name's in the format `MAGE_RUN_CODE:server_name`, i.e. `test_view:test.co.uk` or using a regex `test_view:~test` which would switch Magento to the `test_view` store if the domain name contained the word `test` |

See [edge-docker-php](https://github.com/outeredge/edge-docker-php) for additional options such as SMTP and PHP configuration.
