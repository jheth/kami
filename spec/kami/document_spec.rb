require 'spec_helper'

describe Kami::Document do
  let(:client) { Kami::Client.new('ABC-vRXxiGb7Nty9mXYZ') }
  let(:subject) { Kami::Document.new(client, '797003eeefa82bd465e9b806a592b005') }

  describe '#status' do
    it 'returns status hash' do
      hash = {
        'name' => 'example.pdf',
        'document_identifier' => '797003eeefa82bd465e9b806a592b005',
        'file_status' => 'done',
        'file_error_message' => nil,
        'created_at' => '2016-04-27T22:32:32.098Z'
      }

      VCR.use_cassette('document_status') do
        expect(subject.status).to eq(hash)
      end
    end
  end

  describe '#delete' do
    it 'removes document' do
      VCR.use_cassette('document_delete') do
        expect(subject.delete).to eq('')
      end
    end
  end

  describe '#create_export' do
    it 'schedules creation of document export' do
      hash = {
        'destination_document_identifier' => nil,
        'error_data' => nil,
        'error_type' => nil,
        'export_id' => '6cb4de71-c3d5-40c2-8b88-4774ea92db9a',
        'file_url' => nil,
        'google_file_upload_id' => nil,
        'google_user_id' => nil,
        'id' => '6cb4de71-c3d5-40c2-8b88-4774ea92db9a',
        'status' => 'pending',
        'user_message' => nil
      }
      VCR.use_cassette('document_create_export') do
        expect(subject.create_export(type: :annotation)).to eq(hash)
      end
    end
  end

  describe '#export_file' do
    it 'fetch exported document' do
      hash = {
        'destination_document_identifier' => nil,
        'error_data' => nil,
        'error_type' => nil,
        'export_id' => '6cb4de71-c3d5-40c2-8b88-4774ea92db9a',
        'file_url' => nil,
        'google_file_upload_id' => nil,
        'google_user_id' => nil,
        'id' => '6cb4de71-c3d5-40c2-8b88-4774ea92db9a',
        'status' => 'pending',
        'user_message' => nil
      }

      VCR.use_cassette('document_export_file') do
        expect(subject.export_file('6cb4de71-c3d5-40c2-8b88-4774ea92db9a')).to eq(hash)
      end
    end
  end

  describe '#comments' do
    it 'return array of comments' do
      VCR.use_cassette('document_comments') do
        expect(subject.comments).to eq('comments' => [])
      end
    end
  end

  describe '#session_view_url' do
    it 'returns session view url' do
      VCR.use_cassette('document_session_view_url') do
        prefix = 'https://embed.kamihq.com/web/viewer.html?source=embed_api&document_identifier=797003eeefa82bd465e9b806a592b005'
        expect(subject.session_view_url).to include(prefix)
      end
    end
  end
end
