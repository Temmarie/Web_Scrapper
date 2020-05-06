# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'byebug'

def scrapper
  url = 'https://www.wattpad.com/stories/werewolf'
  unparsed_page = HTTParty.get(url) #get raw html file
  parsed_page = Nokogiri::HTML(unparsed_page)# parse the html file
  books = Array.new
  books_list = parsed_page.css('div.browse-story-item') #20 books
  books_list.each do |book_list|
    book = {
      title: book_list.css('a.title').text,
      author: book_list.css('a.username').text,
      description: book_list.css('div.description').text,
      rating: book_list.css('div.social-meta').text,
      url: book_list.css('a')[0].attributes['href'].value
    }
    books << book
  end
  byebug
end
scrapper
