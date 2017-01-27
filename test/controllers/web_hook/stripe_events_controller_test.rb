# require 'test_helper'
#
# class WebHook::StripeEventsControllerTest < ActionController::TestCase
#   setup do
#     @web_hook_stripe_event = web_hook_stripe_events(:one)
#   end
#
#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:web_hook_stripe_events)
#   end
#
#   test "should get new" do
#     get :new
#     assert_response :success
#   end
#
#   test "should create web_hook_stripe_event" do
#     assert_difference('WebHook::StripeEvent.count') do
#       post :create, web_hook_stripe_event: { api_version: @web_hook_stripe_event.api_version, data: @web_hook_stripe_event.data, livemode: @web_hook_stripe_event.livemode, object: @web_hook_stripe_event.object, request: @web_hook_stripe_event.request, stripe_id: @web_hook_stripe_event.stripe_id }
#     end
#
#     assert_redirected_to web_hook_stripe_event_path(assigns(:web_hook_stripe_event))
#   end
#
#   test "should show web_hook_stripe_event" do
#     get :show, id: @web_hook_stripe_event
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get :edit, id: @web_hook_stripe_event
#     assert_response :success
#   end
#
#   test "should update web_hook_stripe_event" do
#     patch :update, id: @web_hook_stripe_event, web_hook_stripe_event: { api_version: @web_hook_stripe_event.api_version, data: @web_hook_stripe_event.data, livemode: @web_hook_stripe_event.livemode, object: @web_hook_stripe_event.object, request: @web_hook_stripe_event.request, stripe_id: @web_hook_stripe_event.stripe_id }
#     assert_redirected_to web_hook_stripe_event_path(assigns(:web_hook_stripe_event))
#   end
#
#   test "should destroy web_hook_stripe_event" do
#     assert_difference('WebHook::StripeEvent.count', -1) do
#       delete :destroy, id: @web_hook_stripe_event
#     end
#
#     assert_redirected_to web_hook_stripe_events_path
#   end
# end
