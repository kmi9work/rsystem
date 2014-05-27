require 'test_helper'

class NewsParsersControllerTest < ActionController::TestCase
  setup do
    @news_parser = news_parsers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_parsers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create news_parser" do
    assert_difference('NewsParser.count') do
      post :create, news_parser: {  }
    end

    assert_redirected_to news_parser_path(assigns(:news_parser))
  end

  test "should show news_parser" do
    get :show, id: @news_parser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @news_parser
    assert_response :success
  end

  test "should update news_parser" do
    patch :update, id: @news_parser, news_parser: {  }
    assert_redirected_to news_parser_path(assigns(:news_parser))
  end

  test "should destroy news_parser" do
    assert_difference('NewsParser.count', -1) do
      delete :destroy, id: @news_parser
    end

    assert_redirected_to news_parsers_path
  end
end
