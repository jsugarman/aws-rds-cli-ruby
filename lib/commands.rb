# frozen_string_literal: true

# Module to store method overides
# for commands available to the
# aws-rds-sdk client.
#
# for each command available to
# [aws rds cli](https://docs.aws.amazon.com/cli/latest/reference/rds/)
# and available in the [aws-rds-sdk client](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/RDS/Client.html)
# you can define a method here to customize
# its behaviour.
#
# each method should response with a hash
#
module Commands
  # custom filtered outoutput for describe_db_snapshots
  #
  def describe_db_snapshots(db_identifier)
    response = client.describe_db_snapshots(db_identifier)
    response.to_h[:db_snapshots].map do |snapshot|
      {
        db_snapshot_identifier: snapshot[:db_snapshot_identifier],
        snapshot_create_time: snapshot[:snapshot_create_time],
        status: snapshot[:status]
      }
    end.sort_by { |snapshot| snapshot[:snapshot_create_time]&.to_datetime || DateTime.now }.reverse
  end

  # custom filtered outoutput for describe_db_instances
  #
  def describe_db_instances(db_identifier)
    response = client.describe_db_instances(db_identifier)
    response.to_h[:db_instances].map do |instance|
      {
        db_instance_status: instance[:db_instance_status],
        db_instance_identifier: instance[:db_instance_identifier],
        db_instance_class: instance[:db_instance_class],
        engine: "#{instance[:engine]} v#{instance[:engine_version]}",
        db_parameter_groups: instance[:db_parameter_groups]
      }
    end
  end

  # custom create_db_snapshot, waits for snapshot to be available
  #
  def create_db_snapshot(db_identifier)
    params = db_identifier.merge(snapshot_identifier)
    response = client.create_db_snapshot(params)

    printf "[#{Time.now}] Creating snapshot...".green
    client.wait_until(:db_snapshot_available, params) do |w|
      w.before_wait do |_attempts, _response|
        printf '.'.green
      end
    end
    puts "\n[#{Time.now}] Created snaphot #{snapshot_identifier[:db_snapshot_identifier]}".green

    response.to_h
  end
end
