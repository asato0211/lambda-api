# frozen_string_literal: true

require 'json'
require './script/member'
require './script/sqs'

class LambdaContext; end

def lambda_handler(event:, context:)
  puts event
  param = parse(event['body'])
  puts 'receive request'
  puts param

  if param[:member_id].blank?
    return { statusCode: 400, body: JSON.generate('invalid parameter') }
  end

  member = Member.new(param[:member_id])

  if member.cache!
    dump = member.dump
    Sqs.sent(dump)
    { statusCode: 200, body: dump }
  else
    { statusCode: 400, body: JSON.generate('member is not registered') }
  end
rescue => e
  puts 'Internal Error: %s' % e
  { statusCode: 500, body: JSON.generate('Internal Server Error') }
end

def parse request
  body = JSON.parse(request)
  { member_id: body['member_id'] }
end
