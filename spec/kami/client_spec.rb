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
        doc_hash = {
          'name' => 'example.pdf',
          'document_identifier' => '797003eeefa82bd465e9b806a592b005',
          'file_status' => 'done',
          'file_error_message' => nil,
          'created_at' => '2016-04-27T22:32:32.098Z'
        }

        list = subject.documents
        expect(list.size).to eq(1)

        doc = list.first
        expect(doc).to be_instance_of(Kami::Document)
        expect(doc.to_hash).to eq(doc_hash)

        expect(doc.name).to eq doc_hash['name']
        expect(doc.document_identifier).to eq doc_hash['document_identifier']
        expect(doc.file_status).to eq doc_hash['file_status']
        expect(doc.file_error_message).to eq doc_hash['file_error_message']
        expect(doc.created_at).to eq doc_hash['created_at']
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
        expect(response).to eq true
      end
    end
  end
end
