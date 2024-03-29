require 'nokogiri'
require 'open-uri'
require 'uri'

class NewsParser < ActiveRecord::Base
	serialize :queries, Array
	serialize :contents, Hash
	RICH_CONTENT_KEY = "rca.1.1.20140325T124443Z.4617706c8eb8ca49.f55bbec26c11f882a82500daa69448a3e80dfef9"
	XML_KEY = "03.221067681:17248ebd10d4013eab1585f73ddbec5f"
#  unless new_value.blank?
	def add_query str
		@queries ||= []
		@queries << CGI.escape(str).gsub('%2A', '*').gsub('%7E', '~').gsub('%21', '!').gsub('%28', '(').gsub('%29', ')')
		write_attribute(:queries, @queries)
	end

	def run!
		group_count = 5
		in_group = 1
		groupby = "attr%3Dd.mode%3Ddeep.groups-on-page%3D#{group_count}.docs-in-group%3D#{in_group}"
		sortby = "rlv" #"tm.order%3Ddescending" 
		@contents ||= {}
		@queries.each_with_index do |query, index|
			url = "http://xmlsearch.yandex.ru/xmlsearch?user=kmi9-ya&key=#{XML_KEY}&query=#{query}&sortby=#{sortby}&filter=none&maxpassages=1&groupby=#{groupby}&l10n=ru"
			doc = Nokogiri::HTML(open_url(url, "Can't get data from Yandex XML. #{index}"))
			puts doc
			links = doc.css('yandexsearch response results group doc url').map{|l| l.content}
			puts "Links count: #{links.size}"
			links.each_with_index do |link, index|
				puts "#{index}. Processing... " + link
				unless @contents.has_key?(link)
					yandex_rich_url = "http://rca.yandex.com/?key=#{RICH_CONTENT_KEY}&url=#{URI.escape(link)}&content=full"
					doc = open_url(yandex_rich_url, "URL: #{link}")
					if (doc)
						doc = doc.readlines.join	
						rich_ret = JSON.parse(doc)
						@contents[link] = [rich_ret["title"] ? CGI.unescapeHTML(rich_ret["title"]) : "", rich_ret["content"] ? CGI.unescapeHTML(rich_ret["content"]) : ""]
					else
						puts "Can't download #{link}. -----------------"
						next
					end
				end
			end
		end
		write_attribute(:contents, @contents)
	end

private

	def open_url url, err_text = ""
		i = 0
		doc = nil
		while (i += 1 ) <= 2
			begin
				doc = open(url)
				break
			rescue Exception => e
				k = rand(10) + 5
				$stderr.puts "#{url} was not open. Sleep(#{k}). #{i}"
				$stderr.puts e.message 
				$stderr.puts err_text
				# ОБРАБОТАТЬ ПРАВИЛЬНО ОШИБКИ
				sleep(k)
			end
		end
		return nil if i == 10
		return doc
	end

end


