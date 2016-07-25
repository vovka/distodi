require 'test_helper'

class AttributeKindsControllerTest < ActionController::TestCase
  setup do
    @attribute_kind = attribute_kinds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attribute_kinds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attribute_kind" do
    assert_difference('AttributeKind.count') do
      post :create, attribute_kind: { title: @attribute_kind.title }
    end

    assert_redirected_to attribute_kind_path(assigns(:attribute_kind))
  end

  test "should show attribute_kind" do
    get :show, id: @attribute_kind
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attribute_kind
    assert_response :success
  end

  test "should update attribute_kind" do
    patch :update, id: @attribute_kind, attribute_kind: { title: @attribute_kind.title }
    assert_redirected_to attribute_kind_path(assigns(:attribute_kind))
  end

  test "should destroy attribute_kind" do
    assert_difference('AttributeKind.count', -1) do
      delete :destroy, id: @attribute_kind
    end

    assert_redirected_to attribute_kinds_path
  end
end
