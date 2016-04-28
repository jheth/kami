require 'spec_helper'

describe Kami::Client do
  let(:subject) { Kami::Client.new('ABC-vRXxiGb7Nty9mXYZ') }

  describe '#documents' do
    it 'returns list of document uploads' do
      VCR.use_cassette('document_list_empty') do
        expect(subject.documents).to eq([])
      end
    end

    it 'returns list of document uploads' do
      VCR.use_cassette('document_list') do
        expected = [
          {
            'name' => 'example.pdf',
            'document_identifier' => '797003eeefa82bd465e9b806a592b005',
            'file_status' => 'done',
            'file_error_message' => nil,
            'created_at' => '2016-04-27T22:32:32.098Z'
          }
        ]
        expect(subject.documents).to eq(expected)
      end
    end
  end

  describe '#document' do
    it 'returns Kami::Document' do
      expect(subject.document(1234)).to be_instance_of(Kami::Document)
    end

    it 'returns empty hash when document not found' do
      doc = subject.document(1234)
      VCR.use_cassette('document_not_found') do
        expect { doc.status }.to raise_error(RestClient::ResourceNotFound)
      end
    end
  end

  describe '#upload' do
    it 'upload file from disk' do
      filename = "#{Dir.pwd}/spec/fixtures/example.pdf"

      response = nil
      VCR.use_cassette('upload_file_mulipart') do
        response = subject.upload(name: 'sample.pdf', file: filename)
      end

      h = {
        'name' => 'sample.pdf',
        'document_identifier' => 'a88cb5145a5762651ad7bddcccbbee15',
        'file_status' => 'processing',
        'file_error_message' => nil,
        'created_at' => '2016-05-25T14:58:47.400Z'
      }
      expect(response).to eq(h)
    end

    it 'upload file from url' do
      response = {}
      url = 'https://dl.dropboxusercontent.com/u/11644126/example.pdf'
      VCR.use_cassette('upload_file_url') do
        response = subject.upload(name: 'example.pdf', document_url: url)
      end

      h = {
        'name' => 'example.pdf',
        'document_identifier' => '797003eeefa82bd465e9b806a592b005',
        'file_status' => 'processing',
        'file_error_message' => nil,
        'created_at' => '2016-04-27T22:32:32.098Z'
      }

      expect(response).to eq(h)
    end
  end

  describe '#delete' do
    it 'removes document' do
      VCR.use_cassette('document_delete') do
        response = subject.delete_document('797003eeefa82bd465e9b806a592b005')
        expect(response).to eq('')
      end
    end
  end
end
