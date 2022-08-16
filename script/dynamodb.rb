# frozen_string_literal: true

require 'aws-sdk-dynamodb'

# DynamoDB を抽象化
class DynamoDB

  class << self

    # write 時に int を使わない
    def set member
      client.put_item(set_format(member))
    end

    def get member_id
      client.get_item(get_format(member_id))
    end

    private

    def client
      region = 'ap-northeast-1'
      Aws::DynamoDB::Client.new(region: region)
    end

    def set_format member
      {
        table_name: "members",
        item: {
          member_id: member.member_id,
          member_name: member.member_name
        }
      }
    end

    def get_format member_id
      {
        table_name: "members",
        key: {
          member_id: member_id
        }
      }
    end

  end

end
