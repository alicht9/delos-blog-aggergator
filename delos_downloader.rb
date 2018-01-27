#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'prawn'

LAST_PAGE=18
BASE_URL = 'https://svdelos.com/travel-blogs/page/PAGE/?order=ASC'
PAGE_URL= 'https://svdelos.com/travel-blogs/fixing-stuff-remote-places-brian/'
FILE = 'delos-blogs.pdf'
IMAGE_SCALE= 0.5
FONT_PATH = './OpenSans-Regular.ttf'

def crawl_article url
  page = Nokogiri::HTML(open(url))

  blog_title = page.css(".entry-header").text

  blog_text = page.css(".entry-content").text

  image_links = page.css(".alignnone").collect do |tag|
    tag.attr("src")
  end
  
  return [blog_title, blog_text, image_links]
end

def create_pdf data
  Prawn::Document.generate(FILE) do
  font FONT_PATH
    data.each do |p|
      text p[0] 
      text p[1]
      p[2].each {|l| image open(l), scale: IMAGE_SCALE}
    end
  end
end


def get_blog_links base_url
  blog_urls = Array.new
  (1...LAST_PAGE).each do |page|
    this_page = base_url.gsub("PAGE", page.to_s)
    index_page = Nokogiri::HTML((open(this_page)))
    page_urls = index_page.css(".entry-title").collect do |blog_p_tag|
      blog_p_tag.children.first.attr("href")
    end
    #first one is latest
    page_urls.shift
    blog_urls << page_urls
  end
  return blog_urls.flatten
end

if __FILE__ == $0 
  pages = get_blog_links(BASE_URL)

  page_data = pages.collect do |page|
    crawl_article(page)
  end

  create_pdf page_data
end
