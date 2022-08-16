# frozen_string_literal: true

require 'json'
require 'mysql2'
require './script/dynamodb'

# メンバーの操作を行う
# 初回リクエスト時にDBからメンバー情報を取得してDynamoDBに保存 => 次回リクエスト以降はDynamoDBから取得
class Member

  attr_reader :member_id, :member_name

  def initialize member_id
    @member_id = member_id
  end

  def exe_sql
    client = Mysql2::Client.new(
      host: ENV['DB_HOST'],
      user: ENV['DB_USER'],
      password: ENV['DB_PASSWORD'],
      database: ENV['DB_NAME']
    )

    query = \
      "SELECT m.name
       FROM members AS m
       WHERE m.id='%d'" % @member_id

    result = client.query(query).first
    puts 'result: %s' % result
    return nil if result.blank?

    @member_name = result['name']
    result
  end

  def cache!
    begin
      puts 'search cache'
      cached = DynamoDB.get(@member_id)
      unless cached[:item].nil?
        puts 'member is cached'
        @member_name = cached[:item]['member_name']
        return true
      end
      puts 'member is not cached'
    rescue => e
      puts 'Fail to connect to dynamodb'
      raise e
    end

    unless exe_sql.nil?
      p 'try to update cache'
      DynamoDB.set(self)
      p 'updated cache'
      return true
    end

    false
  end

  def dump
    JSON.generate({
      member_id: @member_id,
      member_name: @member_name
    })
  end

end
