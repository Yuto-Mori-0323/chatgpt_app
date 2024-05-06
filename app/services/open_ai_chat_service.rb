# app/services/open_ai_chat_service.rb

require 'httparty'

class OpenAiChatService
  include HTTParty

  def initialize
    api_key = ENV['OPENAI_API_KEY']
    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}"
    }
    @beta_headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}",
      "OpenAI-Beta" => "assistants=v2"
    }
    @base_uri = 'https://api.openai.com/v1'
  end

  def chat_completion(model, messages)
    body = {
      model: model,
      messages: messages
    }.to_json

    response = HTTParty.post("#{@base_uri}/chat/completions", body: body, headers: @headers)
    puts response
  end

  def upload_file(file_path, purpose)
    response = HTTParty.post("#{@base_uri}/files",
      headers: @headers,
      body: {
        file: File.open(file_path, "r"),
        purpose: purpose
      },
      multipart: true
    )
    puts response
  end

  def create_fine_tuning_job(training_file_id, model, epochs=3)
    response = HTTParty.post("#{@base_uri}/fine_tuning/jobs",
      headers: @headers,
      body: {
        training_file: training_file_id,
        model: model,
      }.to_json
    )
    puts response
  end

  # エポックを指定する場合 メモ
  # body: {
  #   training_file: training_file_id,
  #   model: model,
  #   hyperparameters: {
  #     n_epochs: epochs
  #   }
  # }.to_json

  def retrieve_fine_tuning_job(job_id)
    response = HTTParty.get("#{@base_uri}/fine_tuning/jobs/#{job_id}",
      headers: @headers
    )
    puts response
  end

  # ファインチューニングジョブのリストを取得するメソッド
  def list_fine_tuning_jobs(limit = 10)
    response = HTTParty.get(
      "#{@base_uri}/fine_tuning/jobs",
      headers: @headers,
      query: {
        limit: limit
      }
    )
    
    if response.code == 200
      jobs = response.parsed_response["data"]
      jobs.each do |job|
        puts "Job ID: #{job['id']}, Status: #{job['status']}"
      end
    else
      puts "Failed to retrieve fine-tuning jobs: #{response.message}"
    end
  end

  def get_file_content(file_id)
    response = HTTParty.get(
      "#{@base_uri}/files/#{file_id}/content",
      headers: @headers
    )
  
    utf8_content = response.body.force_encoding('UTF-8')
    puts utf8_content
    
  end

  # code_interpreter用
  # def create_assistant(model, name, instructions, tools, files)
  #   response = HTTParty.post("#{@base_uri}/assistants",
  #     headers: @beta_headers,
  #     body: {
  #       model: model,
  #       name: name,
  #       instructions: instructions,
  #       tools: [{type: tools}],
  #       tool_resources: {
  #         "code_interpreter": {
  #           "file_ids": files
  #         }
  #       }
  #     }.to_json
  #   )
  #   puts response
  # end

  # file_search用
  def create_assistant(model, name, instructions, tools, files)
    response = HTTParty.post("#{@base_uri}/assistants",
      headers: @beta_headers,
      body: {
        model: model,
        name: name,
        instructions: instructions,
        tools: [{type: tools}],
        tool_resources: {
          "file_search": {
            "vector_store_ids": files
          }
        }
      }.to_json
    )
    puts response
  end

  def create_thread
    # body = {
    #   assistant_id: assistant_id  # アシスタントIDをリクエストに含める
    # }.to_json
    response = HTTParty.post("#{@base_uri}/threads",
      headers: @beta_headers,
    )
    puts response
  end

  def create_message_to_thread(thread_id, role, content)
    response = HTTParty.post("#{@base_uri}/threads/#{thread_id}/messages",
      headers: @beta_headers,
      body: {
        role: role,
        content: content
      }.to_json
    )
    puts response
  end

  def thread_runs(thread_id, assistant_id)
    response = HTTParty.post("#{@base_uri}/threads/#{thread_id}/runs",
      headers: @beta_headers,
      body: {
        assistant_id: assistant_id,
      }.to_json
    )
    puts response
  end

  def get_messages(thread_id)
    response = HTTParty.get("#{@base_uri}/threads/#{thread_id}/messages",
      headers: @beta_headers,
    )
    puts response
  end

end
