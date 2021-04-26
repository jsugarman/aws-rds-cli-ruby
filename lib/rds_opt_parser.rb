# frozen_string_literal: true

class RdsOptParser
  def self.parse(args)
    options = OpenStruct.new
    options.namespace
    options.identifier
    options.command
    options.wait = false

    rds_opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} [options]"
      opts.separator ''
      opts.separator 'Specific options:'

      opts.on('-c',
              '--command COMMAND',
              'Required: the RDS CLI command to call see https://docs.aws.amazon.com/cli/latest/reference/rds/') do |cmd|
        options.command = cmd.tr('-', '_').downcase.to_sym
      end

      opts.on('-i',
              '--identifier [IDENTIFIER]',
              'Optional: the unique db-instance-identifier of the db instance. or `export AWS_DB_INSTANCE_IDENTIFIER=cloud-platform-qqqqq`') do |id|
        options.identifier = id
      end

      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end

    rds_opt_parser.parse!(args)

    unless options.command
      puts 'command is required!'.red
      puts rds_opt_parser.help
      exit 1
    end

    options
  end
end
