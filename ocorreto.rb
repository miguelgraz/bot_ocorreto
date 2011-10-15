# encoding: utf-8

require 'rubygems'
require 'net/http'
require 'uri'
require 'json'
require 'oauth'

def search(url, wrong, correct)

  begin
    # parse the url we want to access
    uri = URI.parse(url)

    # creating a request object
    req = Net::HTTP.get(uri)

    req = req.to_s
    hash = JSON.parse(req)
    access = login
    hash["results"].each do |tweet|
      puts tweet["from_user"]
      puts tweet["id"]
      last = reply(tweet["from_user"], access, wrong, correct)
      if last.is_a? (Net::HTTPOK)
        @last = (tweet["id"] rescue @last)
      end
      sleep(90)
    end
  rescue
  end
end

def login
  consumer = OAuth::Consumer.new("EA9xBRiRKA0cv43CZgA8hw", "Aq1gyrKnliJVpLxwFqGmzoD3moP8BDKqVWcs2rS2E", {:site => "http://api.twitter.com", :scheme => :header})
  # now create the access token object from passed values
  token_hash = { :oauth_token => '348876777-JOhzzcJg8SmF8Y9s8G5Fhtxsxvthb2Yur8dRamSD',
                 :oauth_token_secret => 'fMQaPBD8aNRVFhz43u8i5znQazHMiZfaZHOURNY'
               }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
end

def reply(from, access_token, correct)
  response = access_token.request(:post, 'http://api.twitter.com/1/statuses/update.json', {:status => "Ei @#{from}, sabia que a forma certa de escrever '#{wrong}' é '#{correct}'? Siga-me para conhecer outros erros comuns."}, {'Content-Type' => 'application/xml' })
  puts response.class
  response.class
end

@last = 107838698829258753
keywords = []
keywords << {:word => "infelismente", :correct => "infeliZmente", :last => @last}
keywords << {:word => "ancioso", :correct => "anSioso", :last => @last}
keywords << {:word => "falcidade", :correct => "falSidade", :last => @last}
keywords << {:word => "enchergar", :correct => "enXergar", :last => @last}
keywords << {:word => "sombrancelhas", :correct => "sobrancelhas", :last => @last}
keywords << {:word => "esplicar", :correct => "eXplicar", :last => @last}
keywords << {:word => "encomodar", :correct => "Incomodar", :last => @last}
keywords << {:word => "geito", :correct => "Jeito", :last => @last}
keywords << {:word => "concerteza", :correct => "com certeza", :last => @last}
keywords << {:word => "simplismente", :correct => "simplEsmente", :last => @last}
keywords.shuffle!

while true do
  keywords.each do |w|
    search("http://search.twitter.com/search.json?q=#{w[:word]}&since_id=#{w[:last]}", "#{w[:word]}", "#{w[:correct]}")
    w[:last] = @last
  end
end
