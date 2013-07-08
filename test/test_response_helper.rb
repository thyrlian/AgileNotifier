require_relative 'helper'

class TestResponseHelper < Test::Unit::TestCase
  def setup
    @pm = ResponseHelper::PrivateMethods.new
  end
  
  def test_get_value_of_key_from_json
    json = {'actions' => [{}, {}, {'buildsByBranchName' => {'origin/master' => {'buildNumber' => 3, 'revision' => {'SHA1' => '08a2be82ba83c1e89e01f698a30203fb0284aa33', 'branch' => [{'SHA1' => '4eac3c2c5b8f2daddeaa37926e7c1f55cd756f1f', 'name' => 'origin/master'}, {'SHA1' => '08a2be82ba83c1e89e01f698a30203fb0284aa33', 'name' => 'origin/HEAD'}]}}}}], 'description' => 'just a test', 'displayName' => 'Test Project', 'url' => 'http://localhost:8080/job/Test%20Project/', 'builds' => [{'number' => 3, 'url' => 'http://localhost:8080/job/Test%20Project/3/'}, {'number' => 2, 'url' => 'http://localhost:8080/job/Test%20Project/2/'}, {'number' => 1, 'url' => 'http://localhost:8080/job/Test%20Project/1/'}], 'lastFailedBuild' => {'number' => 2, 'url' => 'http://localhost:8080/job/Test%20Project/2/'}, 'lastSuccessfulBuild' => {'number' => 3, 'url' => 'http://localhost:8080/job/Test%20Project/3/'}}
    assert_equal('origin/master', @pm.get_value_of_key_from_json('name', json)) # find first occurrence
    assert_equal('08a2be82ba83c1e89e01f698a30203fb0284aa33', @pm.get_value_of_key_from_json('SHA1', json)) # find first occurrence
    assert_equal(3, @pm.get_value_of_key_from_json('number', json)) # find first occurrence
    assert_equal('Test Project', @pm.get_value_of_key_from_json('displayName', json))
    assert_equal('http://localhost:8080/job/Test%20Project/3/', @pm.get_value_of_key_from_json('lastSuccessfulBuild', json)['url'])
    assert_equal(nil, @pm.get_value_of_key_from_json('sexyGirl', json)) # nonexistent key should return nil
  end
end