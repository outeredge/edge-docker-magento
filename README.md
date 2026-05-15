# edge-docker-magento-dev

Magento running on Docker with FrankenPHP. Designed for development use only.

Regularly updated with the latest releases.

## Configuration Options
Most configuration can be done with environment variables. 

See [edge-docker-php-dev](https://github.com/outeredge/edge-docker-php-dev) and [edge-docker-php](https://github.com/outeredge/edge-docker-php) for the available options such as SMTP and PHP configuration.

## PHP versions

Please refer to the table below for the PHP version in use by recent releases:

| Magento Release (image tag)   | PHP     |
| ----------------------------- | ------- |
| 2.4.9                         | 8.4     |
| 2.4.7, 2.4.8                  | 8.3     |

## Building

If you want to build this image yourself you will need to export the `$MAGENTO_COMPOSER_AUTH` environment variable. You could do this in `~/.bashrc` like so (replace keys with your Magento composer keys):

```
export MAGENTO_COMPOSER_AUTH="{\"http-basic\":{\"repo.magento.com\":{\"username\":\"REPLACEME\",\"password\":\"REPLACEME\"}}}"
```
