Ruby::OpenAI.configure do |config|
        config.access_token = ENV.fetch('OPEN_AI')
        #config.organization_id = ENV.fetch('OPENAI_ORGANIZATION_ID') # Optional.
    end