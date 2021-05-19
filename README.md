Simple wrapper for the [Aws::RDS::Client](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/RDS/Client.html) with the aim of aiding upgrading in particular.

## Requirements:
```sh
gem install aws-sdk-rds
gem install colorize
gem install awesome_print
```

## Setup:
```sh
export AWS_ACCESS_KEY_ID=aaaaaaaaa
export AWS_SECRET_ACCESS_KEY=aaaaaa
export AWS_DEFAULT_REGION=aaaaaaaaa
export AWS_DB_INSTANCE_IDENTIFIER=aaaaaaaaa
```

## Example usage
```sh
bin/rds -c describe-db-instances
bin/rds -c describe-db-snapshots
bin/rds -c create-db-snapshot
bin/rds -c describe-db-snapshots -i my-other-db-instance-identifier
```

## Wait for instance status to be available
Useful if you are modifying a db-parameter-group or upgrading a DB instance
```sh
bin/rds -c describe-db-instances --wait
```

## Customized commands
the `Commands` module contains overides for some client methods to customize responses to output what ever is most pertinant, add waiting or doing anything else the client is able to do.

| cli method | client ruby method | customized version effect |
|-|-|-|
| describe-db-instances | describe_db_instances | outputs summary of all instances |
| describe-db-snapshots | describe_db_snapshots | outputs summary of all snapshots |
| create-db-snapshot | create_db_snapshot | waits until snapshot is available |

You can add your own custom commands by adding a method to `lib/commands.rb`. Typically this would be named after the applicable cli method (replace hyphens with underscores) and ensure it returns a hash. You can however create you own command entirely - e.g. `def my_custom_snapshot` say, and call it using `bin/rds -c my-custom-snapshot`.

