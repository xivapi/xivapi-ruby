require 'xivapi/version'

require 'xivapi/errors'
require 'xivapi/http'
require 'xivapi/page'
require 'xivapi/paginator'
require 'xivapi/request'

require 'rest-client'
require 'json'
require 'ostruct'

# Base module for the XIVAPI library
module XIVAPI
  # The allowed language options
  LANGUAGE_OPTIONS = %w(en ja de fr cn kr).freeze

  # The required format for tags
  TAGS_FORMAT = /^[a-z0-9\-_]+$/i.freeze

  # Client for making requests to XIVAPI
  class Client
    include XIVAPI::Request

    # @return [String] The API key
    attr_accessor :api_key

    # Initializes a new client for querying XIVAPI
    # @param api_key [String] API key provided by XIVAPI
    # @param language [String] Requested response langauge
    # @param poll_rate [Integer] Frequency at which to poll when waiting for data to cache
    # @param tags [String, Array<String>] Optional string tag(s) for tracking requests
    def initialize(api_key: nil, language: :en, poll_rate: 30, tags: nil)
      @api_key = api_key

      self.language = language
      self.poll_rate = poll_rate
      self.tags = tags if tags
    end

    # @return [String] The language
    def language
      @language
    end

    # @param language [String, Symbol] The language to set for the client
    # @return The language
    def language=(language)
      lang = language.to_s.downcase
      raise ArgumentError, 'Unsupported language' unless LANGUAGE_OPTIONS.include?(lang)
      @language = lang
    end

    # @return [Integer] The rate at which cached requests are polled
    def poll_rate
      @poll_rate
    end

    # @param rate [Integer] The rate at which to poll cached requests
    # @return [Integer] The poll rate
    def poll_rate=(rate)
      raise ArgumentError, 'Poll rate must be a positive integer' unless rate.is_a?(Integer) && rate > 0
      @poll_rate = rate
    end

    # @return [String] The tags sent along with each request
    def tags
      @tags
    end

    # @param tags [String, Array<String>] The tags to be sent along with each request
    # @return [String] The tags
    def tags=(tags)
      raise ArgumentError, 'Invalid tag format' unless [*tags].each { |tag| tag.match?(TAGS_FORMAT) }
      @tags = [*tags].join(',')
    end

    # @return [Hash] The default parameters for the client
    def default_params
      { key: @api_key, language: @language, tags: @tags }
    end
  end
end
