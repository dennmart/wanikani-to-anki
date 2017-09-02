require 'spec_helper'

describe 'ExportController' do
  let(:api_key_session) { { 'rack.session' => { wanikani_api_key: 'valid-api-key' } } }

  describe '/export' do
    before(:each) do
      allow_any_instance_of(Wanikani::Client).to receive(:user_information).and_return('username' => 'dennmart')
    end

    it 'redirects to the home page if the session key is not set' do
      get '/export', {}, 'rack.session' => {}
      expect(last_response).to be_redirect
      expect(last_response.location).to eq('http://example.org/')
    end

    it 'does not redirect if the session key is set' do
      get '/export', {}, api_key_session
      expect(last_response).to_not be_redirect
    end
  end

  describe '/export/generate' do
    it 'calls WanikaniApi.fetch_* using the deck type and params' do
      params = { 'deck_type' => 'critical', 'argument' => '85' }
      expect_any_instance_of(WanikaniApi).to receive(:send).with('fetch_critical', params).and_return([{"type" => "vocabulary", "character" => "地下", "kana" => "ちか"}])
      post '/export/generate', params, api_key_session
    end

    it 'redirects to /export if the deck is nil' do
      allow_any_instance_of(WanikaniApi).to receive(:send).and_return([])
      post '/export/generate', { deck_type: 'critical' }, api_key_session
      expect(last_response).to be_redirect
      expect(last_response.location).to eq('http://example.org/export')
    end

    it 'prepares a plain text file ready to download' do
      allow_any_instance_of(WanikaniApi).to receive(:send).and_return(
        [
          {
            'type' => 'radical',
            'character' => "久",
            'meaning' => 'raptor-cage',
            'image' => nil,
            'level' => 3,
            'percentage' => '79'
          },
          {
            'type' => 'vocabulary',
            'character' => "入る",
            'kana' => "はいる",
            'meaning' => 'to enter',
            'level' => 1,
            'percentage' => '85'
          },
          {
            'type' => 'kanji',
            'character' => "九",
            'meaning' => 'nine',
            'onyomi' => "く, きゅう",
            'kunyomi' => "ここの.*",
            'important_reading' => 'onyomi',
            'level' => 1,
            'percentage' => '87'
          }
        ]
      )
      post '/export/generate', { deck_type: 'critical' }, api_key_session
      expect(last_response['Content-Type']).to eq('text/plain;charset=utf-8')
    end
  end
end
