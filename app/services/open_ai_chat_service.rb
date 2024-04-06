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

  def upload_dataset(file_path)
    response = HTTParty.post("#{@base_uri}/files",
      headers: @headers,
      body: {
        file: File.open(file_path, "r"),
        purpose: "fine-tune"
      },
      multipart: true
    )
    puts response
  end

  def create_fine_tuning_job(training_file_id, model)
    response = HTTParty.post("#{@base_uri}/fine_tuning/jobs",
      headers: @headers,
      body: {
        training_file: training_file_id,
        model: model
      }.to_json
    )
    puts response
  end

  def retrieve_fine_tuning_job(job_id)
    response = HTTParty.get("#{@base_uri}/fine_tuning/jobs/#{job_id}",
      headers: @headers
    )
    puts response
  end
end
