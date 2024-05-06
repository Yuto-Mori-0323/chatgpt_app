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
response = service.upload_file('lib/data/tuning002.jsonl', 'fine-tune')

※ アシスタントに使うためには
response = service.upload_file('lib/data/tuning002.jsonl', 'assistants')

* ジョブ作成  
job_response = service.create_fine_tuning_job('file-gMwqsc5JLs9ApEj09uHmJwzr', 'gpt-3.5-turbo')  
※テキスト生成時のidを入力する  

* 状態確認  
job_status = service.retrieve_fine_tuning_job('ftjob-NBXWIsdKFmX9O8hc19sqyCEg')  
※ジョブ作成時のidを入力する  
statusがsucceededになったら、fine_tuned_modelに記載された文字列をメモし
テキスト生成のモデルに指定する

* アシスタント作成
response = service.create_assistant("gpt-3.5-turbo", "カスタマーサポート２", "ユーザーからの問い合わせに対して返信メッセージを作成します", "file_search", ["vs_izYRAWyFXEWX5eejoQN9mpVc"])


vs_izYRAWyFXEWX5eejoQN9mpVc

* スレッド作成
response = service.create_thread

thread_McgWYbkVuG1TkRbxsK3ejNU5

* メッセージをスレッドに付与
response = service.create_message_to_thread("thread_7ygZRc6PW2ZfcnYO1nJRXjZq", "user", "処方せんはどのくらいの時間で発行され、薬局で薬を受け取れるようになりますか？")

* スレッドを実行
response = service.thread_runs("thread_7ygZRc6PW2ZfcnYO1nJRXjZq", "asst_VoQ5BG5OYbYlyoeWNGsPcOYi")

* メッセージの取得
response = service.get_messages("thread_7ygZRc6PW2ZfcnYO1nJRXjZq")

