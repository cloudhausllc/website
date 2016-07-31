require 'test_helper'

class Asset::ToolTest < ActiveSupport::TestCase
  setup do
    @tool = Asset::Tool.new(
        active: true,
        on_premises: true,
        value: 100,
        name: 'Test tool',
        user_id: users(:admin_user),
        quantity: 1,
        url: 'https://cloudhaus.org',
        sqft: 1,
        model_number: 'MODEL12345',
        notes: 'No notes.'
    )
  end

  test 'active is required' do
    @tool.active = nil
    assert_not @tool.valid?
  end

  test 'on_premises is required' do
    @tool.on_premises = nil
    assert_not @tool.valid?
  end

  test 'value is required' do
    @tool.value = nil
    assert_not @tool.valid?
  end

  test 'name is required' do
    [nil, '', ' '].each do |test_value|
      @tool.name = test_value
      assert_not @tool.valid?
    end
  end

  test 'user_id is required' do
    @tool.user_id = nil
    assert_not @tool.valid?
  end

  test 'quantity must be valid' do
    ['', ' ', nil, -1, 'a'].each do |test_value|
      @tool.quantity = test_value
      assert_not @tool.valid?, "#{test_value} should not be a valid value for quantity"
    end
  end


  test 'sqft is required' do
    ['', ' ', nil, -1, 'a'].each do |test_value|
      @tool.sqft = test_value
      assert_not @tool.valid?, "#{test_value} should not be a valid value for sqft"
    end
  end
end
