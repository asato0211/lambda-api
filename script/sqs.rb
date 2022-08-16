# frozen_string_literal: true

require 'aws-sdk-sqs'

# SQS
class Sqs

  def sent dump
    sqs = Aws::SQS::Client.new(region: 'ap-northeast-1')

    sqs.send_message(
      queue_url: ENV['QUEUE_URL'],
      message_body: dump
    )
  rescue => e
    puts "Error: #{e}"
    raise e
  end

end
