# edge-docker-magento
Magento running on Docker. Plays nicely with Gitpod & Eclipse Che. Designed for development use only.

Regularly updated with the latest 2.* releases (see branches).

## Configuration Options
Most configuration can be done with environment variables. Here are the available options:

| Environment       | Default | Description |
| -------------     | ------- | --- |
| MAGE_MODE         | -       | Set's the Magento [mode](http://devdocs.magento.com/guides/v2.3/config-guide/bootstrap/magento-modes.html), this is usualy `default` if not set elsewhere |
| MAGE_ENV          | -       | Specify the environment file extension to use (i.e. `env.php.$MAGE_ENV`),  if not set, will look for `env.php.$MAGE_MODE` |
| ENABLE_CRON       | Off     | Enables the Magento cron jobs |
| ADDITIONAL_STORES | -       | Comma separated list of Magento store codes and Nginx server_name's in the format `MAGE_RUN_CODE:server_name`, i.e. `test_view:test.co.uk` or using a regex `test_view:~test` which would switch Magento to the `test_view` store if the domain name contained the word `test` |

See [edge-docker-php](https://github.com/outeredge/edge-docker-php) for additional options such as SMTP and PHP configuration.

## PHP versions

Please refer to the table below for the PHP version in use by recent releases:

| Magento Release (image tag)   | PHP     |
| ----------------------------- | ------- |
| 2.4.4                         | 8.1     |
| 2.4.2, 2.4.3                  | 7.4     |
| 2.4.1, 2.4.0, 2.3.6           | 7.3     |
| 2.3.5, 2.3.4                  | 7.2     |
