module Kami
  class Document
    attr_reader :name, :document_identifier, :file_status, :file_error_message,
                :created_at, :session_view

    def initialize(client: nil, id: nil, data: nil)
      @client = client
      @document_identifier = id
      @raw_data = data

      if data.is_a?(Hash)
        @name = data['name']
        @document_identifier = data['document_identifier']
        @file_status = data['file_status']
        @file_error_message = data['file_error_message']
        @created_at = data['created_at']
      end
    end

    def to_hash
      @raw_data || status
    end

    def status
      @status ||= @client.get("documents/#{@document_identifier}")
    end

    def create_export(type: 'annotation')
      payload = {
        document_identifier: @document_identifier,
        export_type: type
      }
      @export = @client.post('exports', payload)
    end

    def export_file(id = nil)
      export_id = id
      export_id ||= @export['id'] if @export.is_a?(Hash)

      @client.get("exports/#{export_id}")
    end

    def delete
      @client.delete("documents/#{@document_identifier}")
      true
    end

    def comments
      @client.get("documents/#{@document_identifier}/comments")
    end

    def session_view(name: 'Guest', user_id: 0)
      return unless @document_identifier

      payload = {
        document_identifier: @document_identifier,
        user: {
          name: name,
          user_id: user_id
        },
        expires_at: (Time.now + (60 * 60))
      }

      @session_view = @client.post('sessions', payload)
    end

    def session_view_url(name: 'Guest', user_id: 0)
      view = session_view(name: name, user_id: user_id)
      view['viewer_url']
    end
  end
end
