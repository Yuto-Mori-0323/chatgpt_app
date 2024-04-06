# 前提条件
* open AIのコンソールでAPIキーを発行する
https://platform.openai.com/api-keys

料金についてはこちら
https://openai.com/pricing

* APIキーをenvのOPENAI_API_KEYにセットする

# 利用手順
rails console
service = OpenAiChatService.new

* テキスト生成
response = service.chat_completion("gpt-3.5-turbo", [
  {role: "user", content: "処方せんはどのくらいの時間で発行され、薬局で薬を受け取れるようになりますか？"}
])

* ファイルアップロード
dataset_response = service.upload_dataset('lib/data/tuning002.jsonl')

* ジョブ作成
job_response = service.create_fine_tuning_job('file-gMwqsc5JLs9ApEj09uHmJwzr', 'gpt-3.5-turbo')
※テキスト生成時のidを入力する

* 状態確認
job_status = service.retrieve_fine_tuning_job('ftjob-NBXWIsdKFmX9O8hc19sqyCEg')
※ジョブ作成時のidを入力する
statusがsucceededになったら、fine_tuned_modelに記載された文字列をメモし
テキスト生成のモデルに指定する